# PowerShell script to update all widgets with flutter_screenutil responsive values
# Run this from the project root directory

$projectRoot = "f:\TEMPLATES\Flutter\flutter_clean_architecture"
$widgetsToUpdate = @(
    "lib\shared\widgets\cards\product_card.dart",
    "lib\shared\widgets\cards\info_card.dart",
    "lib\shared\widgets\cards\custom_card.dart",
    "lib\shared\widgets\common\avatar.dart",
    "lib\shared\widgets\common\badge.dart",
    "lib\shared\widgets\common\chip.dart",
    "lib\shared\widgets\common\divider.dart",
    "lib\shared\widgets\common\rating.dart",
    "lib\shared\widgets\common\tag.dart",
    "lib\shared\widgets\common\timeline.dart",
    "lib\shared\widgets\common\empty_state.dart",
    "lib\shared\widgets\common\error_widget.dart",
    "lib\shared\widgets\common\loading_indicator.dart",
    "lib\shared\widgets\common\loading_overlay.dart",
    "lib\shared\widgets\dialogs\app_dialogs.dart",
    "lib\shared\widgets\dialogs\app_snackbars.dart",
    "lib\shared\widgets\bottom_sheets\modal_bottom_sheet.dart",
    "lib\shared\widgets\app_bars\custom_app_bar.dart",
    "lib\shared\widgets\pagination\pagination_widgets.dart"
)

Write-Host "Starting responsive update for widgets..." -ForegroundColor Cyan
Write-Host ""

$updatedCount = 0
$failedFiles = @()

foreach ($file in $widgetsToUpdate) {
    $fullPath = Join-Path $projectRoot $file
    
    if (Test-Path $fullPath) {
        Write-Host "Processing: $file" -ForegroundColor Yellow
        
        try {
            $content = Get-Content $fullPath -Raw
            
            # Check if already has flutter_screenutil import
            if ($content -notmatch "flutter_screenutil") {
                # Add import after the material import
                $materialImport = "import 'package:flutter/material.dart';"
                $newImport = "$materialImport`nimport 'package:flutter_screenutil/flutter_screenutil.dart';"
                $content = $content -replace [regex]::Escape($materialImport), $newImport
            }
            
            # Convert common hardcoded values
            # Padding and EdgeInsets
            $content = $content -creplace 'EdgeInsets\.all\((\d+)\)', 'EdgeInsets.all($1.w)'
            $content = $content -creplace 'EdgeInsets\.symmetric\(horizontal:\s*(\d+),\s*vertical:\s*(\d+)\)', 'EdgeInsets.symmetric(horizontal: $1.w, vertical: $2.h)'
            $content = $content -creplace 'EdgeInsets\.symmetric\(horizontal:\s*(\d+)\)', 'EdgeInsets.symmetric(horizontal: $1.w)'
            $content = $content -creplace 'EdgeInsets\.symmetric\(vertical:\s*(\d+)\)', 'EdgeInsets.symmetric(vertical: $1.h)'
            $content = $content -creplace 'EdgeInsets\.only\(top:\s*(\d+)\)', 'EdgeInsets.only(top: $1.h)'
            $content = $content -creplace 'EdgeInsets\.only\(bottom:\s*(\d+)\)', 'EdgeInsets.only(bottom: $1.h)'
            $content = $content -creplace 'EdgeInsets\.only\(left:\s*(\d+)\)', 'EdgeInsets.only(left: $1.w)'
            $content = $content -creplace 'EdgeInsets\.only\(right:\s*(\d+)\)', 'EdgeInsets.only(right: $1.w)'
            
            # SizedBox
            $content = $content -creplace 'SizedBox\(width:\s*(\d+)\)', 'SizedBox(width: $1.w)'
            $content = $content -creplace 'SizedBox\(height:\s*(\d+)\)', 'SizedBox(height: $1.h)'
            $content = $content -creplace 'SizedBox\(width:\s*(\d+),\s*height:\s*(\d+)\)', 'SizedBox(width: $1.w, height: $2.h)'
            
            # BorderRadius
            $content = $content -creplace 'BorderRadius\.circular\((\d+)\)', 'BorderRadius.circular($1.r)'
            $content = $content -creplace 'Radius\.circular\((\d+)\)', 'Radius.circular($1.r)'
            
            # Font sizes in TextStyle
            $content = $content -creplace 'fontSize:\s*(\d+),', 'fontSize: $1.sp,'
            $content = $content -creplace 'fontSize:\s*(\d+)\)', 'fontSize: $1.sp)'
            
            # Icon sizes
            $content = $content -creplace 'size:\s*(\d+),', 'size: $1.sp,'
            $content = $content -creplace 'size:\s*(\d+)\)', 'size: $1.sp)'
            
            # Container dimensions
            $content = $content -creplace 'width:\s*(\d+),', 'width: $1.w,'
            $content = $content -creplace 'height:\s*(\d+),', 'height: $1.h,'
            
            # Save the updated content
            Set-Content -Path $fullPath -Value $content -NoNewline
            
            Write-Host "   Updated successfully" -ForegroundColor Green
            $updatedCount++
        }
        catch {
            Write-Host "   Failed: $($_.Exception.Message)" -ForegroundColor Red
            $failedFiles += $file
        }
    }
    else {
        Write-Host "   File not found: $file" -ForegroundColor Magenta
        $failedFiles += $file
    }
    
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Update Summary:" -ForegroundColor Cyan
Write-Host "   Total files processed: $($widgetsToUpdate.Count)" -ForegroundColor White
Write-Host "   Successfully updated: $updatedCount" -ForegroundColor Green
Write-Host "   Failed: $($failedFiles.Count)" -ForegroundColor Red
Write-Host ""

if ($failedFiles.Count -gt 0) {
    Write-Host "Failed files:" -ForegroundColor Red
    foreach ($file in $failedFiles) {
        Write-Host "   - $file" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run: flutter format lib" -ForegroundColor Yellow
Write-Host "2. Run: flutter analyze" -ForegroundColor Yellow
Write-Host "3. Check for any compilation errors" -ForegroundColor Yellow
Write-Host "4. Test the app thoroughly" -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: Some manual adjustments might be needed!" -ForegroundColor Yellow
Write-Host "Review the changes before committing." -ForegroundColor Yellow
