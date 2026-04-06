# Comprehensive fix script for responsive styling issues
# Applies proper best practices from SCREENUTIL_PROPER_USAGE.md

$widgetDir = "f:\TEMPLATES\Flutter\flutter_clean_architecture\lib\shared\widgets"
$fixed = 0
$errors = 0

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Fixing Responsive Styling Issues" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

function Fix-WidgetFile {
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
        
        # Fix 1: strokeWidth .w -> .r
        if ($content -match 'strokeWidth:\s*(\d+)\.w\b') {
            $content = $content -creplace 'strokeWidth:\s*(\d+)\.w\b', 'strokeWidth: $1.r'
            $changes += "strokeWidth .w -> .r"
        }
        
        # Fix 2: strokeWidth without extension -> .r
        if ($content -match 'strokeWidth:\s*(\d+)(?!\.)\s*[,)]') {
            $content = $content -creplace 'strokeWidth:\s*(\d+)(?!\.)', 'strokeWidth: $1.r'
            $changes += "strokeWidth hardcoded -> .r"
        }
        
        # Fix 3: Border width .w -> .r
        $content = $content -creplace '(border[^}]*width:\s*)(\d+)\.w\b', '$1$2.r'
        $content = $content -creplace '(Border\.all\([^}]*width:\s*)(\d+)\.w\b', '$1$2.r'
        if ($originalContent -ne $content) {
            $changes += "border width .w -> .r"
        }
        
        # Fix 4: Loading indicator square (height .h, width .w with same value) -> both .r
        # CircularProgressIndicator with height: 20.h, width: 20.w -> both .r
        $content = $content -creplace '(height:\s*)(\d+)\.h\s*,\s*(width:\s*)\2\.w\b', '$1$2.r, $3$2.r'
        $content = $content -creplace '(width:\s*)(\d+)\.w\s*,\s*(height:\s*)\2\.h\b', '$1$2.r, $3$2.r'
        if ($originalContent -ne $content) {
            $changes += "square dimensions -> .r"
        }
        
        # Fix 5: Remove const from EdgeInsets/SizedBox with extensions
        $content = $content -creplace '\bconst\s+(EdgeInsets\.[^;{]*\.\s*(?:w|h|r|sp)\b)', '$1'
        $content = $content -creplace '\bconst\s+(SizedBox\([^}]*\.\s*(?:w|h|r|sp)\b)', '$1'
        $content = $content -creplace '\bconst\s+(BorderRadius\.[^}]*\.\s*r\b)', '$1'
        if ($originalContent -ne $content) {
            $changes += "removed const with extensions"
        }
        
        # Fix 6: Common hardcoded values in specific patterns
        # Border width: 1, 2, 3 -> .r
        $content = $content -creplace '(border[^}]*width:\s*)([123])(?!\.)\s*([,)])', '$1$2.r$3'
        
        # Icon sizes without extension -> .sp
        $content = $content -creplace '(Icon\([^}]*size:\s*)(\d+)(?!\.)\s*([,)])', '$1$2.sp$3'
        
        # CircularProgressIndicator strokeWidth -> .r
        $content = $content -creplace '(CircularProgressIndicator[^}]*strokeWidth:\s*)(\d+)(?!\.)', '$1$2.r'
        
        if ($originalContent -ne $content) {
            $changes += "fixed hardcoded values"
        }
        
        # Fix 7: Add flutter_screenutil import if missing and changes were made
        if ($content -ne $originalContent -and $content -notmatch "import 'package:flutter_screenutil/flutter_screenutil.dart';") {
            $content = $content -creplace "(import 'package:flutter/material.dart';)", "`$1`nimport 'package:flutter_screenutil/flutter_screenutil.dart';"
            $changes += "added import"
        }
        
        # Write changes if any
        if ($content -ne $originalContent) {
            Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  FIXED: $($changes -join ', ')" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  No automated fixes" -ForegroundColor Gray
            return $false
        }
        
    } catch {
        Write-Host "  ERROR: $_" -ForegroundColor Red
        $script:errors++
        return $false
    }
}

# Process all widget files
$widgetFiles = Get-ChildItem -Path $widgetDir -Filter "*.dart" -Recurse

foreach ($file in $widgetFiles) {
    if (Fix-WidgetFile -filePath $file.FullName) {
        $fixed++
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Files fixed: $fixed" -ForegroundColor Green
Write-Host "Errors: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })
Write-Host ""
Write-Host "Manual fixes still needed:" -ForegroundColor Yellow
Write-Host "  1. Size/width/height parameters without extensions" -ForegroundColor Gray
Write-Host "  2. Complex calculations (size * 0.5, etc.)" -ForegroundColor Gray
Write-Host "  3. Context-specific icon sizes (.sp vs .r)" -ForegroundColor Gray
Write-Host ""
Write-Host "Next: Run 'dart format lib' to format code" -ForegroundColor Cyan
