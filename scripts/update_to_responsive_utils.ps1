# Script to update widgets to use ResponsiveSpacing helpers instead of direct extensions
# This ensures consistency and easier maintenance

$widgetDir = "f:\TEMPLATES\Flutter\flutter_clean_architecture\lib\shared\widgets"
$utilsImport = "import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';"
$updated = 0
$errors = 0

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Updating Widgets to Use ResponsiveSpacing Helpers" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

function Update-WidgetFile {
    param (
        [string]$filePath
    )
    
    $fileName = Split-Path $filePath -Leaf
    $relativePath = $filePath.Replace("$widgetDir\", "")
    Write-Host "Processing: $relativePath" -ForegroundColor Yellow
    
    try {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        $originalContent = $content
        $changes = @()
        
        # Skip export file
        if ($fileName -eq "widget.dart") {
            Write-Host "  Skipped (export file)" -ForegroundColor Gray
            return $false
        }
        
        # Replace common EdgeInsets patterns with ResponsiveSpacing helpers
        # EdgeInsets.all(X.w) -> ResponsiveSpacing.all(X)
        if ($content -match 'EdgeInsets\.all\((\d+)\.w\)') {
            $content = $content -creplace 'EdgeInsets\.all\((\d+)\.w\)', 'ResponsiveSpacing.all($1)'
            $changes += "EdgeInsets.all -> ResponsiveSpacing.all"
        }
        
        # EdgeInsets.symmetric(horizontal: X.w, vertical: Y.h) -> ResponsiveSpacing.symmetric(horizontal: X, vertical: Y)
        if ($content -match 'EdgeInsets\.symmetric\([^)]*\.(?:w|h)\)') {
            $content = $content -creplace 'EdgeInsets\.symmetric\(\s*horizontal:\s*(\d+)\.w\s*,\s*vertical:\s*(\d+)\.h\s*\)', 'ResponsiveSpacing.symmetric(horizontal: $1, vertical: $2)'
            $content = $content -creplace 'EdgeInsets\.symmetric\(\s*vertical:\s*(\d+)\.h\s*,\s*horizontal:\s*(\d+)\.w\s*\)', 'ResponsiveSpacing.symmetric(horizontal: $2, vertical: $1)'
            $changes += "EdgeInsets.symmetric -> ResponsiveSpacing.symmetric"
        }
        
        # EdgeInsets.only(...) -> ResponsiveSpacing.only(...)
        if ($content -match 'EdgeInsets\.only\([^)]*\.(?:w|h)\)') {
            # This is complex, let's handle common patterns
            $content = $content -creplace 'EdgeInsets\.only\(\s*left:\s*(\d+)\.w\s*,\s*top:\s*(\d+)\.h\s*,\s*right:\s*(\d+)\.w\s*,\s*bottom:\s*(\d+)\.h\s*\)', 'ResponsiveSpacing.only(left: $1, top: $2, right: $3, bottom: $4)'
            $content = $content -creplace 'EdgeInsets\.only\(\s*top:\s*(\d+)\.h\s*\)', 'ResponsiveSpacing.only(top: $1)'
            $content = $content -creplace 'EdgeInsets\.only\(\s*bottom:\s*(\d+)\.h\s*\)', 'ResponsiveSpacing.only(bottom: $1)'
            $content = $content -creplace 'EdgeInsets\.only\(\s*left:\s*(\d+)\.w\s*\)', 'ResponsiveSpacing.only(left: $1)'
            $content = $content -creplace 'EdgeInsets\.only\(\s*right:\s*(\d+)\.w\s*\)', 'ResponsiveSpacing.only(right: $1)'
            $changes += "EdgeInsets.only -> ResponsiveSpacing.only"
        }
        
        # Replace common hardcoded values with ResponsiveSpacing constants
        # 16.w -> ResponsiveSpacing.lg
        # 12.w -> ResponsiveSpacing.md
        # 8.w -> ResponsiveSpacing.sm
        # 4.w -> ResponsiveSpacing.xs
        # 20.w -> ResponsiveSpacing.xl
        # 24.w -> ResponsiveSpacing.xxl
        
        # Replace in fontSize context
        if ($content -match 'fontSize:\s*\d+\.sp') {
            $content = $content -creplace 'fontSize:\s*14\.sp', 'fontSize: ResponsiveFontSizes.md'
            $content = $content -creplace 'fontSize:\s*16\.sp', 'fontSize: ResponsiveFontSizes.lg'
            $content = $content -creplace 'fontSize:\s*12\.sp', 'fontSize: ResponsiveFontSizes.sm'
            $content = $content -creplace 'fontSize:\s*18\.sp', 'fontSize: ResponsiveFontSizes.xl'
            $content = $content -creplace 'fontSize:\s*20\.sp', 'fontSize: ResponsiveFontSizes.xxl'
            $content = $content -creplace 'fontSize:\s*24\.sp', 'fontSize: ResponsiveFontSizes.xxxl'
            $content = $content -creplace 'fontSize:\s*10\.sp', 'fontSize: ResponsiveFontSizes.xs'
            $changes += "fontSize -> ResponsiveFontSizes"
        }
        
        # Replace in icon size context
        if ($content -match 'size:\s*\d+\.sp') {
            $content = $content -creplace '(?<!font)size:\s*20\.sp', 'size: ResponsiveSpacing.iconSm'
            $content = $content -creplace '(?<!font)size:\s*24\.sp', 'size: ResponsiveSpacing.iconMd'
            $content = $content -creplace '(?<!font)size:\s*32\.sp', 'size: ResponsiveSpacing.iconLg'
            $content = $content -creplace '(?<!font)size:\s*16\.sp', 'size: ResponsiveSpacing.iconXs'
            $changes += "icon size -> ResponsiveSpacing.icon"
        }
        
        # Replace BorderRadius with ResponsiveSpacing.radius
        if ($content -match 'BorderRadius\.circular\(\d+\.r\)') {
            $content = $content -creplace 'BorderRadius\.circular\(12\.r\)', 'BorderRadius.circular(ResponsiveSpacing.radiusMd)'
            $content = $content -creplace 'BorderRadius\.circular\(8\.r\)', 'BorderRadius.circular(ResponsiveSpacing.radiusSm)'
            $content = $content -creplace 'BorderRadius\.circular\(16\.r\)', 'BorderRadius.circular(ResponsiveSpacing.radiusLg)'
            $content = $content -creplace 'BorderRadius\.circular\(4\.r\)', 'BorderRadius.circular(ResponsiveSpacing.radiusXs)'
            $content = $content -creplace 'BorderRadius\.circular\(20\.r\)', 'BorderRadius.circular(ResponsiveSpacing.radiusXl)'
            $changes += "BorderRadius -> ResponsiveSpacing.radius"
        }
        
        # Add import if changes were made and import is missing
        if ($content -ne $originalContent) {
            if ($content -notmatch [regex]::Escape($utilsImport)) {
                # Add import after flutter_screenutil import
                $content = $content -creplace "(import 'package:flutter_screenutil/flutter_screenutil.dart';)", "`$1`n$utilsImport"
                $changes += "added import"
            }
        }
        
        # Write changes if any
        if ($content -ne $originalContent) {
            Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  UPDATED: $($changes -join ', ')" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  No updates needed" -ForegroundColor Gray
            return $false
        }
        
    } catch {
        Write-Host "  ERROR: $_" -ForegroundColor Red
        $script:errors++
        return $false
    }
}

# Target specific directories
$targetDirs = @(
    "buttons",
    "inputs",
    "cards"
)

foreach ($dir in $targetDirs) {
    $dirPath = Join-Path $widgetDir $dir
    if (Test-Path $dirPath) {
        $files = Get-ChildItem -Path $dirPath -Filter "*.dart"
        foreach ($file in $files) {
            if (Update-WidgetFile -filePath $file.FullName) {
                $updated++
            }
        }
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Files updated: $updated" -ForegroundColor Green
Write-Host "Errors: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""
Write-Host "Changes applied:" -ForegroundColor Yellow
Write-Host "  - EdgeInsets.all/symmetric/only -> ResponsiveSpacing helpers" -ForegroundColor Gray
Write-Host "  - fontSize values -> ResponsiveFontSizes constants" -ForegroundColor Gray
Write-Host "  - Icon sizes -> ResponsiveSpacing.icon constants" -ForegroundColor Gray
Write-Host "  - BorderRadius values -> ResponsiveSpacing.radius constants" -ForegroundColor Gray
Write-Host ""
Write-Host "Next: Run 'dart format lib' to format code" -ForegroundColor Cyan
