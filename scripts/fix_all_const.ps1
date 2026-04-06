# PowerShell script to fix ALL remaining const errors
$projectRoot = "f:\TEMPLATES\Flutter\flutter_clean_architecture"

# Get all dart files in widgets directory
$dartFiles = Get-ChildItem -Path "$projectRoot\lib\shared\widgets" -Filter *.dart -Recurse | Select-Object -ExpandProperty FullName

Write-Host "Fixing const expressions in all widget files..." -ForegroundColor Cyan
Write-Host ""

$fixedCount = 0
$totalFiles = $dartFiles.Count

foreach ($fullPath in $dartFiles) {
    $relativePath = $fullPath.Replace("$projectRoot\", "")
    
    try {
        $content = Get-Content $fullPath -Raw
        $originalContent = $content
        
        # Remove ALL const keywords that precede expressions with .w, .h, .sp, or .r
        $content = $content -creplace '\bconst\s+(EdgeInsets\.[a-zA-Z]+\([^)]*\.(w|h)[^)]*\))', '$1'
        $content = $content -creplace '\bconst\s+(SizedBox\([^)]*\.(w|h)[^)]*\))', '$1'
        $content = $content -creplace '\bconst\s+(BorderRadius\.[^)]*\.r[^)]*\))', '$1'
        $content = $content -creplace '\bconst\s+(Radius\.[^)]*\.r[^)]*\))', '$1'
        $content = $content -creplace '\bconst\s+(Icon\([^)]*\.sp[^)]*\))', '$1'
        $content = $content -creplace '\bconst\s+(TextStyle\([^)]*\.sp[^)]*\))', '$1'
        
        # More specific patterns for nested cases
        $content = $content -creplace '(\s+)const\s+EdgeInsets\.all\((\d+)\.w\)', '$1EdgeInsets.all($2.w)'
        $content = $content -creplace '(\s+)const\s+EdgeInsets\.symmetric\((horizontal|vertical):\s*(\d+)\.(w|h)\)', '$1EdgeInsets.symmetric($2: $3.$4)'
        $content = $content -creplace '(\s+)const\s+EdgeInsets\.symmetric\(horizontal:\s*(\d+)\.w,\s*vertical:\s*(\d+)\.h\)', '$1EdgeInsets.symmetric(horizontal: $2.w, vertical: $3.h)'
        $content = $content -creplace '(\s+)const\s+EdgeInsets\.only\((top|bottom|left|right):\s*(\d+)\.(w|h)\)', '$1EdgeInsets.only($2: $3.$4)'
        
        $content = $content -creplace '(\s+)const\s+SizedBox\((width|height):\s*(\d+)\.(w|h)\)', '$1SizedBox($2: $3.$4)'
        $content = $content -creplace '(\s+)const\s+SizedBox\(width:\s*(\d+)\.w,\s*height:\s*(\d+)\.h\)', '$1SizedBox(width: $2.w, height: $3.h)'
        
        $content = $content -creplace '(\s+)const\s+Icon\(([^,]+),\s*size:\s*(\d+)\.sp([,)])', '$1Icon($2, size: $3.sp$4)'
        
        # Remove unused import if present and no extension used
        if ($content -notmatch '\.\s*(w|h|sp|r)\b') {
            $content = $content -replace "import 'package:flutter_screenutil/flutter_screenutil.dart';\r?\n", ""
        }
        
        if ($content -ne $originalContent) {
            Set-Content -Path $fullPath -Value $content -NoNewline
            Write-Host "Fixed: $relativePath" -ForegroundColor Green
            $fixedCount++
        }
    }
    catch {
        Write-Host "Error in $relativePath : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================"  -ForegroundColor Cyan
Write-Host "Fixed $fixedCount out of $totalFiles files" -ForegroundColor Green
Write-Host "Running dart format..." -ForegroundColor Yellow
