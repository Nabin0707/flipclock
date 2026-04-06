# Script to properly update theme with responsive values

$filePath = "lib\core\theme\app_theme.dart"
$content = Get-Content $filePath -Raw

# Add import at the top
$content = $content -replace "(import 'package:flutter_clean_architecture/core/theme/app_colors.dart';)", "`$1`nimport 'package:flutter_screenutil/flutter_screenutil.dart';"

# Fix specific patterns carefully - numbers with explicit context

# AppBar fontSize
$content = $content -replace "fontSize: 18,", "fontSize: 18.sp,"

# Button and input font sizes
$content = $content -replace "fontSize: 14,", "fontSize: 14.sp,"
$content = $content -replace "fontSize: 12,", "fontSize: 12.sp,"

# Icon sizes  
$content = $content -replace "size: 24,", "size: 24.r,"

# Border radius - with context
$content = $content -replace "borderRadius: BorderRadius\.circular\((\d+)\)", "borderRadius: BorderRadius.circular(`$1.r)"
$content = $content -replace "Radius\.circular\((\d+)\)", "Radius.circular(`$1.r)"

# Button heights
$content = $content -replace "Size\.fromHeight\((\d+)\)", "Size.fromHeight(`$1.r)"

# Padding
$content = $content -replace "EdgeInsets\.symmetric\(horizontal: (\d+), vertical: (\d+)\)", "EdgeInsets.symmetric(horizontal: `$1.r, vertical: `$2.r)"
$content = $content -replace "EdgeInsets\.all\((\d+)\)", "EdgeInsets.all(`$1.r)"

# Border width
$content = $content -replace "width: 1\.5\)", "width: 1.5.r)"
$content = $content -replace "width: 1\)", "width: 1.r)"
$content = $content -replace "width: 2\)", "width: 2.r)"

# Divider
$content = $content -replace "thickness: 1,", "thickness: 1.r,"
$content = $content -replace "space: 1,", "space: 1.r,"

# Remove const where needed
$content = $content -replace "const EdgeInsets\.symmetric", "EdgeInsets.symmetric"
$content = $content -replace "const EdgeInsets\.all", "EdgeInsets.all"
$content = $content -replace "const Size\.fromHeight", "Size.fromHeight"
$content = $content -replace "const TextStyle\(", "TextStyle("
$content = $content -replace "const BorderSide\(", "BorderSide("
$content = $content -replace "const IconThemeData\(color:", "IconThemeData(color:"
$content = $content -replace "const AppBarTheme\(", "AppBarTheme("
$content = $content -replace "const DividerThemeData\(", "DividerThemeData("
$content = $content -replace "const BottomSheetThemeData\(", "BottomSheetThemeData("
$content = $content -replace "const FloatingActionButtonThemeData\(", "FloatingActionButtonThemeData("

# Save
Set-Content -Path $filePath -Value $content -NoNewline

Write-Host "✅ Theme file updated successfully!" -ForegroundColor Green
Write-Host "Formatting..." -ForegroundColor Cyan
& dart format lib/core/theme/app_theme.dart
