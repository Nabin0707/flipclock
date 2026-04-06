# PowerShell script to remove 'const' keyword where extension methods are used
# This fixes the "Extension methods can't be used in constant expressions" error

$projectRoot = "f:\TEMPLATES\Flutter\flutter_clean_architecture"
$filesToFix = @(
    "lib\shared\widgets\cards\product_card.dart",
    "lib\shared\widgets\cards\info_card.dart",
    "lib\shared\widgets\cards\custom_card.dart",
    "lib\shared\widgets\bottom_sheets\modal_bottom_sheet.dart",
    "lib\shared\widgets\dialogs\app_dialogs.dart",
    "lib\shared\widgets\dialogs\app_snackbars.dart"
)

Write-Host "Fixing const expressions with extension methods..." -ForegroundColor Cyan
Write-Host ""

$fixedCount = 0

foreach ($file in $filesToFix) {
    $fullPath = Join-Path $projectRoot $file
    
    if (Test-Path $fullPath) {
        Write-Host "Processing: $file" -ForegroundColor Yellow
        
        try {
            $content = Get-Content $fullPath -Raw
            
            # Remove const from expressions that use extension methods
            # EdgeInsets with .w or .h
            $content = $content -replace 'const EdgeInsets\.all\((\d+)\.w\)', 'EdgeInsets.all($1.w)'
            $content = $content -replace 'const EdgeInsets\.symmetric\(horizontal:\s*(\d+)\.w,\s*vertical:\s*(\d+)\.h\)', 'EdgeInsets.symmetric(horizontal: $1.w, vertical: $2.h)'
            $content = $content -replace 'const EdgeInsets\.symmetric\(horizontal:\s*(\d+)\.w\)', 'EdgeInsets.symmetric(horizontal: $1.w)'
            $content = $content -replace 'const EdgeInsets\.symmetric\(vertical:\s*(\d+)\.h\)', 'EdgeInsets.symmetric(vertical: $1.h)'
            $content = $content -replace 'const EdgeInsets\.only\(top:\s*(\d+)\.h\)', 'EdgeInsets.only(top: $1.h)'
            $content = $content -replace 'const EdgeInsets\.only\(bottom:\s*(\d+)\.h\)', 'EdgeInsets.only(bottom: $1.h)'
            $content = $content -replace 'const EdgeInsets\.only\(left:\s*(\d+)\.w\)', 'EdgeInsets.only(left: $1.w)'
            $content = $content -replace 'const EdgeInsets\.only\(right:\s*(\d+)\.w\)', 'EdgeInsets.only(right: $1.w)'
            
            # SizedBox with .w or .h
            $content = $content -replace 'const SizedBox\(width:\s*(\d+)\.w\)', 'SizedBox(width: $1.w)'
            $content = $content -replace 'const SizedBox\(height:\s*(\d+)\.h\)', 'SizedBox(height: $1.h)'
            $content = $content -replace 'const SizedBox\(width:\s*(\d+)\.w,\s*height:\s*(\d+)\.h\)', 'SizedBox(width: $1.w, height: $2.h)'
            
            # BorderRadius with .r
            $content = $content -replace 'const BorderRadius\.circular\((\d+)\.r\)', 'BorderRadius.circular($1.r)'
            $content = $content -replace 'const BorderRadius\.vertical\(top:\s*Radius\.circular\((\d+)\.r\)\)', 'BorderRadius.vertical(top: Radius.circular($1.r))'
            $content = $content -replace 'const Radius\.circular\((\d+)\.r\)', 'Radius.circular($1.r)'
            
            # Icon with size: X.sp
            $content = $content -replace 'const Icon\(([^,]+),\s*size:\s*(\d+)\.sp\)', 'Icon($1, size: $2.sp)'
            
            # TextStyle with fontSize: X.sp inside const context
            $content = $content -replace '(const\s+TextStyle\([^)]*fontSize:\s*)(\d+)(\.sp[,)])', '$1$2.sp$3'
            $content = $content -replace 'const\s+(TextStyle\([^)]*\bfontSize:\s*\d+\.sp[^)]*\))', '$1'
            
            # Save the updated content
            Set-Content -Path $fullPath -Value $content -NoNewline
            
            Write-Host "   Fixed successfully" -ForegroundColor Green
            $fixedCount++
        }
        catch {
            Write-Host "   Failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "   File not found: $file" -ForegroundColor Magenta
    }
    
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fix Summary:" -ForegroundColor Cyan
Write-Host "   Total files processed: $($filesToFix.Count)" -ForegroundColor White
Write-Host "   Successfully fixed: $fixedCount" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Run 'dart format lib' to format the code" -ForegroundColor Yellow
