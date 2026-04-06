# Script to apply proper responsive styling to all shared widgets
# Following best practices from SCREENUTIL_PROPER_USAGE.md

$widgetDir = "f:\TEMPLATES\Flutter\flutter_clean_architecture\lib\shared\widgets"
$processedFiles = 0
$errors = 0

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Applying Proper Responsive Styling to All Widgets" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# Function to process a file
function Process-WidgetFile {
    param (
        [string]$filePath
    )
    
    $fileName = Split-Path $filePath -Leaf
    Write-Host "Processing: $fileName" -ForegroundColor Yellow
    
    try {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        $originalContent = $content
        
        # Skip if file doesn't contain responsive code or is the export file
        if ($fileName -eq "widget.dart" -or $content -notmatch '\.(w|h|sp|r)\b') {
            Write-Host "  ⊘ Skipped (no responsive code)" -ForegroundColor Gray
            return
        }
        
        # Issue 1: Loading spinner using .w for strokeWidth instead of .r
        # Before: strokeWidth: 2.w or strokeWidth: 2
        # After: strokeWidth: 2.r
        $content = $content -creplace 'strokeWidth:\s*(\d+)\.w\b', 'strokeWidth: $1.r'
        $content = $content -creplace 'strokeWidth:\s*(\d+)(?!\.)', 'strokeWidth: $1.r'
        
        # Issue 2: Square containers using different .w and .h (should use .r for both)
        # Look for width and height with same numeric value but different extensions
        # This is complex, so we'll document it for manual review
        
        # Issue 3: Icon sizes that should use .sp instead of size calculations
        # Icon sizes in text context should use .sp
        # But icons that are decorative can use .r
        
        # Issue 4: Border width should use .r for proportional scaling
        $content = $content -creplace 'width:\s*(\d+)\.w,?\s*\/\/.*border', 'width: $1.r, // border'
        
        # Issue 5: Font sizes must always use .sp
        # Already should be done, but ensure no fontSize without .sp
        
        # Issue 6: Const EdgeInsets with extension methods (already fixed)
        
        # Issue 7: Size parameters passed without responsive extensions
        # This needs manual review - parameters like 'size', 'width', 'height' used directly
        
        # Issue 8: Replace hardcoded numbers in calculations
        # For proportional sizes like size * 0.5, we should use the size parameter with .r if it's for square elements
        
        # Add import if not present and changes were made
        if ($content -ne $originalContent) {
            if ($content -notmatch "import 'package:flutter_screenutil/flutter_screenutil.dart';") {
                # Add import after other imports
                $content = $content -creplace "(import 'package:flutter/material\.dart';)", "`$1`nimport 'package:flutter_screenutil/flutter_screenutil.dart';"
            }
        }
        
        # Write back if changed
        if ($content -ne $originalContent) {
            Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  ✓ Updated" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  ○ No changes needed" -ForegroundColor Gray
            return $false
        }
        
    } catch {
        Write-Host "  ✗ Error: $_" -ForegroundColor Red
        $script:errors++
        return $false
    }
}

# Process all widget files recursively
$widgetFiles = Get-ChildItem -Path $widgetDir -Filter "*.dart" -Recurse | Where-Object { $_.Name -ne "widget.dart" }

foreach ($file in $widgetFiles) {
    if (Process-WidgetFile -filePath $file.FullName) {
        $processedFiles++
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Files updated: $processedFiles" -ForegroundColor Green
Write-Host "Errors: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""
Write-Host "Note: Some issues require manual review:" -ForegroundColor Yellow
Write-Host "  1. Square containers (width/height should both use .r)" -ForegroundColor Yellow
Write-Host "  2. Size parameters used directly without extensions" -ForegroundColor Yellow
Write-Host "  3. Proportional calculations (size * 0.5, etc.)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Run 'dart format lib' to format the files" -ForegroundColor Cyan
