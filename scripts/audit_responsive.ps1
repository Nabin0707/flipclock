# Audit script to find responsive styling issues in widgets
# Identifies patterns that violate best practices from SCREENUTIL_PROPER_USAGE.md

$widgetDir = "f:\TEMPLATES\Flutter\flutter_clean_architecture\lib\shared\widgets"
$issues = @()

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Auditing Responsive Styling Best Practices" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

function Audit-WidgetFile {
    param (
        [string]$filePath
    )
    
    $fileName = Split-Path $filePath -Leaf
    $relativePath = $filePath.Replace("$widgetDir\", "")
    $content = Get-Content $filePath -Raw -Encoding UTF8
    $lines = Get-Content $filePath -Encoding UTF8
    $fileIssues = @()
    
    # Skip export file
    if ($fileName -eq "widget.dart") { return }
    
    # Issue 1: strokeWidth using .w instead of .r
    if ($content -match 'strokeWidth:\s*\d+\.w') {
        $fileIssues += "❌ strokeWidth uses .w (should use .r for proportional)"
    }
    if ($content -match 'strokeWidth:\s*\d+(?!\.)') {
        $lineNums = @()
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match 'strokeWidth:\s*\d+(?!\.)') {
                $lineNums += ($i + 1)
            }
        }
        if ($lineNums.Count -gt 0) {
            $fileIssues += "❌ strokeWidth without extension at lines: $($lineNums -join ', ')"
        }
    }
    
    # Issue 2: Border width using .w instead of .r
    if ($content -match 'width:\s*\d+\.w.*border|Border\.all\([^)]*width:\s*\d+\.w') {
        $fileIssues += "⚠️  Border width uses .w (should use .r)"
    }
    
    # Issue 3: Square containers with different extensions
    # Width .w and height .h for same numeric value
    if ($content -match 'width:\s*(\d+)\.w[,\s]+height:\s*\1\.h|height:\s*(\d+)\.h[,\s]+width:\s*\2\.w') {
        $fileIssues += "❌ Square container uses .w and .h (should use .r for both)"
    }
    
    # Issue 4: Size parameter used directly without extension
    if ($content -match '\bsize\s*[,;)]|width:\s*size\b|height:\s*size\b|:\s*size\s*[*\/]') {
        $fileIssues += "⚠️  'size' parameter used without responsive extension"
    }
    
    # Issue 5: Width or height parameter used directly
    if ($content -match '(?<!final |double |num )\bwidth\b(?!\:)|(?<!final |double |num )\bheight\b(?!\:)' -and 
        $content -match 'width:\s*width\b|height:\s*height\b|Size\(width|Size\.fromHeight\(height') {
        $fileIssues += "⚠️  width/height parameters used without responsive extension"
    }
    
    # Issue 6: Hardcoded pixel values without extension
    $hardcodedMatches = [regex]::Matches($content, '(?:width|height|fontSize|size|padding|margin):\s*(\d+)(?!\.|\s*\/)')
    if ($hardcodedMatches.Count -gt 0) {
        $values = $hardcodedMatches | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
        $fileIssues += "❌ Hardcoded values without extension: $($values -join ', ')"
    }
    
    # Issue 7: fontSize without .sp
    if ($content -match 'fontSize:\s*\d+\.(?!sp)') {
        $fileIssues += "❌ fontSize uses wrong extension (must use .sp)"
    }
    
    # Issue 8: Icon size without .sp or .r
    if ($content -match 'Icon\([^)]*size:\s*\d+\.w') {
        $fileIssues += "⚠️  Icon size uses .w (should use .sp for text-context or .r for decorative)"
    }
    
    # Issue 9: CircularProgressIndicator height/width using .h and .w differently
    if ($content -match 'CircularProgressIndicator[^}]*height:\s*(\d+)\.h[^}]*width:\s*(\d+)\.w' -and $matches[1] -eq $matches[2]) {
        $fileIssues += "❌ Loading indicator uses .h and .w (should use .r for square)"
    }
    
    # Issue 10: const with extension methods
    if ($content -match 'const\s+(?:EdgeInsets|SizedBox|BorderRadius|Icon)[^;]*\.\s*(?:w|h|sp|r)\b') {
        $fileIssues += "❌ const used with extension methods (must remove const)"
    }
    
    if ($fileIssues.Count -gt 0) {
        Write-Host "📄 $relativePath" -ForegroundColor Yellow
        foreach ($issue in $fileIssues) {
            Write-Host "   $issue" -ForegroundColor $(if ($issue.StartsWith("❌")) { "Red" } else { "Yellow" })
        }
        Write-Host ""
        
        $script:issues += [PSCustomObject]@{
            File = $relativePath
            Issues = $fileIssues
        }
    }
}

# Process all widget files
$widgetFiles = Get-ChildItem -Path $widgetDir -Filter "*.dart" -Recurse

foreach ($file in $widgetFiles) {
    Audit-WidgetFile -filePath $file.FullName
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Files with issues: $($issues.Count)" -ForegroundColor $(if ($issues.Count -gt 0) { "Yellow" } else { "Green" })
Write-Host ""

if ($issues.Count -eq 0) {
    Write-Host "All widgets follow best practices!" -ForegroundColor Green
} else {
    Write-Host "Review SCREENUTIL_PROPER_USAGE.md for fixes" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Common fixes:" -ForegroundColor Yellow
    Write-Host "  - strokeWidth: Use .r instead of .w" -ForegroundColor Gray
    Write-Host "  - Square elements: Use .r for both" -ForegroundColor Gray
    Write-Host "  - Border width: Use .r" -ForegroundColor Gray
    Write-Host "  - fontSize: Always use .sp" -ForegroundColor Gray
    Write-Host "  - Icon size: Use .sp or .r" -ForegroundColor Gray
    Write-Host "  - Parameters: Apply extensions" -ForegroundColor Gray
}
