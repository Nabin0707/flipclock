# PowerShell script to batch apply flutter_screenutil responsive values
# This script converts hardcoded values to responsive values throughout the app

$libPath = "f:\TEMPLATES\Flutter\flutter_clean_architecture\lib"

# Function to add import if not exists
function Add-ScreenUtilImport {
    param($filePath)
    
    $content = Get-Content $filePath -Raw
    $import = "import 'package:flutter_screenutil/flutter_screenutil.dart';"
    
    if ($content -notmatch "flutter_screenutil") {
        # Find the last import statement
        if ($content -match '(?m)^import .*?;[\r\n]+') {
            $lastImport = $Matches[0]
            $content = $content -replace [regex]::Escape($lastImport), "$lastImport$import`n"
            Set-Content $filePath -Value $content -NoNewline
            Write-Host "Added ScreenUtil import to: $filePath"
        }
    }
}

# Function to apply responsive transformations
function Apply-ResponsiveTransforms {
    param($filePath)
    
    $content = Get-Content $filePath -Raw
    $modified = $false
    
    # Skip if file is already heavily using ScreenUtil
    if (($content -match "\.w" -and $content -match "\.h" -and $content -match "\.sp") -or 
        $content -match "ScreenUtilInit") {
        Write-Host "Skipping (already responsive): $filePath"
        return
    }
    
    # Transform EdgeInsets.all
    if ($content -match 'EdgeInsets\.all\((\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'EdgeInsets\.all\((\d+(?:\.\d+)?)\)', 'EdgeInsets.all($1.w)'
        $modified = $true
    }
    
    # Transform EdgeInsets.symmetric
    if ($content -match 'EdgeInsets\.symmetric\((.*?)\)') {
        $content = $content -replace 'horizontal:\s*(\d+(?:\.\d+)?)', 'horizontal: $1.w'
        $content = $content -replace 'vertical:\s*(\d+(?:\.\d+)?)', 'vertical: $1.h'
        $modified = $true
    }
    
    # Transform EdgeInsets.only
    if ($content -match 'EdgeInsets\.only') {
        $content = $content -replace '(left|right):\s*(\d+(?:\.\d+)?)', '$1: $2.w'
        $content = $content -replace '(top|bottom):\s*(\d+(?:\.\d+)?)', '$1: $2.h'
        $modified = $true
    }
    
    # Transform SizedBox with width
    if ($content -match 'SizedBox\(width:\s*(\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'SizedBox\(width:\s*(\d+(?:\.\d+)?)\)', 'SizedBox(width: $1.w)'
        $modified = $true
    }
    
    # Transform SizedBox with height
    if ($content -match 'SizedBox\(height:\s*(\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'SizedBox\(height:\s*(\d+(?:\.\d+)?)\)', 'SizedBox(height: $1.h)'
        $modified = $true
    }
    
    # Transform SizedBox with both width and height
    if ($content -match 'SizedBox\(width:\s*(\d+(?:\.\d+)?),\s*height:\s*(\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'SizedBox\(width:\s*(\d+(?:\.\d+)?),\s*height:\s*(\d+(?:\.\d+)?)\)', 'SizedBox(width: $1.w, height: $2.h)'
        $modified = $true
    }
    
    # Transform BorderRadius.circular
    if ($content -match 'BorderRadius\.circular\((\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'BorderRadius\.circular\((\d+(?:\.\d+)?)\)', 'BorderRadius.circular($1.r)'
        $modified = $true
    }
    
    # Transform Radius.circular
    if ($content -match 'Radius\.circular\((\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'Radius\.circular\((\d+(?:\.\d+)?)\)', 'Radius.circular($1.r)'
        $modified = $true
    }
    
    # Transform icon sizes
    if ($content -match 'size:\s*(\d+(?:\.\d+)?)(?!\.w|\.h|\.sp)') {
        # Only transform if it's likely an icon size (common values: 12-48)
        $content = $content -replace '(?<=[Icon|size].*?)size:\s*(\d+(?:\.\d+)?)(?!\.w|\.h|\.sp)', 'size: $1.sp'
        $modified = $true
    }
    
    # Transform fontSize in TextStyle
    if ($content -match 'fontSize:\s*(\d+(?:\.\d+)?)(?!\.sp)') {
        $content = $content -replace 'fontSize:\s*(\d+(?:\.\d+)?)(?!\.sp)', 'fontSize: $1.sp'
        $modified = $true
    }
    
    # Transform width/height in Size
    if ($content -match 'Size\((\d+(?:\.\d+)?),\s*(\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'Size\((\d+(?:\.\d+)?),\s*(\d+(?:\.\d+)?)\)', 'Size($1.w, $2.h)'
        $modified = $true
    }
    
    # Transform height in Size.fromHeight
    if ($content -match 'Size\.fromHeight\((\d+(?:\.\d+)?)\)') {
        $content = $content -replace 'Size\.fromHeight\((\d+(?:\.\d+)?)\)', 'Size.fromHeight($1.h)'
        $modified = $true
    }
    
    # Transform strokeWidth
    if ($content -match 'strokeWidth:\s*(\d+(?:\.\d+)?)(?!\.w)') {
        $content = $content -replace 'strokeWidth:\s*(\d+(?:\.\d+)?)(?!\.w)', 'strokeWidth: $1.w'
        $modified = $true
    }
    
    # Transform border width
    if ($content -match 'width:\s*(\d+(?:\.\d+)?)(?!\.w)' -and $content -match 'BorderSide') {
        $content = $content -replace '(?<=BorderSide.*?)width:\s*(\d+(?:\.\d+)?)(?!\.w)', 'width: $1.w'
        $modified = $true
    }
    
    if ($modified) {
        Set-Content $filePath -Value $content -NoNewline
        Write-Host "Applied responsive transforms to: $filePath"
        Add-ScreenUtilImport $filePath
    }
}

# Get all Dart files in lib folder (excluding generated files)
$dartFiles = Get-ChildItem -Path $libPath -Filter "*.dart" -Recurse | 
    Where-Object { $_.FullName -notmatch "generated|\.g\.dart|\.freezed\.dart" }

Write-Host "Found $($dartFiles.Count) Dart files to process"
Write-Host "Starting responsive value transformation..."
Write-Host ""

$processed = 0
foreach ($file in $dartFiles) {
    Apply-ResponsiveTransforms $file.FullName
    $processed++
    
    if ($processed % 10 -eq 0) {
        Write-Host "Progress: $processed/$($dartFiles.Count) files processed"
    }
}

Write-Host ""
Write-Host "✅ Transformation complete!"
Write-Host "Processed $processed files"
Write-Host "Run 'flutter pub get' and 'dart format lib' to finalize"
