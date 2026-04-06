# PowerShell script to fix icon sizes from .sp to ResponsiveSpacing constants
# This fixes the "icons are huge" issue by using proper icon size constants

$ErrorActionPreference = "Stop"
$filesUpdated = 0
$errors = 0

# Import statement to add if not present
$importStatement = "import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';"

# Mapping of icon sizes (.sp) to ResponsiveSpacing constants
$iconSizeMap = @{
    "80.sp" = "ResponsiveSpacing.iconXxl * 1.67"
    "64.sp" = "ResponsiveSpacing.iconXxl * 1.33"
    "48.sp" = "ResponsiveSpacing.iconXxl"
    "40.sp" = "ResponsiveSpacing.iconXl"
    "32.sp" = "ResponsiveSpacing.iconLg"
    "24.sp" = "ResponsiveSpacing.iconMd"
    "20.sp" = "ResponsiveSpacing.iconSm"
    "18.sp" = "ResponsiveSpacing.iconXs * 1.125"
    "16.sp" = "ResponsiveSpacing.iconXs"
    "14.sp" = "ResponsiveSpacing.iconXs * 0.875"
    "12.sp" = "ResponsiveSpacing.iconXs * 0.75"
    "9.sp" = "ResponsiveSpacing.iconXs * 0.5625"
}

# Files to process (based on grep search results)
$filesToProcess = @(
    "lib\shared\widgets\cards\product_card.dart",
    "lib\shared\widgets\dialogs\app_dialogs.dart",
    "lib\shared\widgets\dialogs\app_snackbars.dart",
    "lib\shared\widgets\common\empty_state.dart",
    "lib\shared\widgets\common\error_widget.dart",
    "lib\shared\widgets\pagination\pagination_widgets.dart",
    "lib\shared\widgets\common\chip.dart",
    "lib\shared\widgets\common\divider.dart",
    "lib\shared\widgets\common\rating.dart",
    "lib\shared\widgets\common\tag.dart",
    "lib\shared\widgets\common\timeline.dart",
    "lib\shared\widgets\buttons\icon_button.dart"
)

function Update-IconSizes {
    param (
        [string]$filePath
    )
    
    if (-not (Test-Path $filePath)) {
        Write-Host "File not found: $filePath" -ForegroundColor Red
        return $false
    }
    
    $content = Get-Content $filePath -Raw
    $originalContent = $content
    $changed = $false
    
    # Check if import exists
    $needsImport = $content -notmatch [regex]::Escape("responsive_utils.dart")
    
    # Replace icon sizes with ResponsiveSpacing constants
    foreach ($size in $iconSizeMap.Keys) {
        $escapedSize = [regex]::Escape($size)
        $pattern = "size:\s*$escapedSize"
        if ($content -match $pattern) {
            $replacement = "size: $($iconSizeMap[$size])"
            $content = $content -replace $pattern, $replacement
            $changed = $true
            Write-Host "  Replaced '$size' with '$($iconSizeMap[$size])'" -ForegroundColor Green
        }
    }
    
    # Fix iconSize?.sp pattern in icon_button.dart
    if ($filePath -like "*icon_button.dart") {
        $pattern = "size:\s*iconSize\?\.sp"
        if ($content -match $pattern) {
            $content = $content -replace $pattern, "size: (iconSize ?? 24).r"
            $changed = $true
            Write-Host "  Replaced 'iconSize?.sp' with '(iconSize ?? 24).r'" -ForegroundColor Green
        }
    }
    
    # Add import if needed and changes were made
    if ($changed -and $needsImport) {
        # Simple approach: add import after first import line
        $lines = $content -split "`n"
        $inserted = $false
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "^import\s+" -and -not $inserted) {
                # Find the last import
                $lastImportIndex = $i
                for ($j = $i + 1; $j -lt $lines.Length; $j++) {
                    if ($lines[$j] -match "^import\s+") {
                        $lastImportIndex = $j
                    } elseif ($lines[$j] -match "\S") {
                        break
                    }
                }
                # Insert after last import
                $newLines = $lines[0..$lastImportIndex]
                $newLines += $importStatement
                $newLines += $lines[($lastImportIndex + 1)..($lines.Length - 1)]
                $content = $newLines -join "`n"
                $inserted = $true
                Write-Host "  Added responsive_utils.dart import" -ForegroundColor Cyan
                break
            }
        }
    }
    
    # Write back if changed
    if ($changed) {
        Set-Content -Path $filePath -Value $content -NoNewline
        return $true
    }
    
    return $false
}

Write-Host ""
Write-Host "Fixing Icon Sizes (replacing .sp with ResponsiveSpacing constants)" -ForegroundColor Yellow
Write-Host "This fixes the 'icons are huge' issue by using proper .r-based scaling" -ForegroundColor White
Write-Host ""

foreach ($file in $filesToProcess) {
    $fullPath = Join-Path $PSScriptRoot $file
    Write-Host "Processing: $file" -ForegroundColor Cyan
    
    try {
        if (Update-IconSizes -filePath $fullPath) {
            $filesUpdated++
            Write-Host "Updated: $file" -ForegroundColor Green
            Write-Host ""
        } else {
            Write-Host "No changes needed: $file" -ForegroundColor Gray
            Write-Host ""
        }
    } catch {
        $errors++
        Write-Host "Error processing ${file}: $_" -ForegroundColor Red
        Write-Host ""
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  Files updated: $filesUpdated" -ForegroundColor Green
Write-Host "  Errors: $errors" -ForegroundColor $(if ($errors -gt 0) { "Red" } else { "Green" })

if ($filesUpdated -gt 0) {
    Write-Host ""
    Write-Host "Icon sizes fixed! Running dart format..." -ForegroundColor Green
    & dart format lib
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Test the app to verify icon sizes look correct" -ForegroundColor White
    Write-Host "  2. Check both portrait and landscape orientations" -ForegroundColor White
    Write-Host "  3. Test with different text scaling settings" -ForegroundColor White
}
