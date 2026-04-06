# Script to update dark theme with responsive values using .r

$filePath = "lib\core\theme\app_theme.dart"
$content = Get-Content $filePath -Raw

# Define replacements for dark theme
$replacements = @(
    @{
        Old = "      // AppBar Theme`n      appBarTheme: const AppBarTheme(`n        centerTitle: true,`n        elevation: 0,`n        scrolledUnderElevation: 1,`n        backgroundColor: AppColors.darkSurface,`n        foregroundColor: AppColors.darkTextPrimary,`n        surfaceTintColor: Colors.transparent,`n        systemOverlayStyle: SystemUiOverlayStyle.light,`n        titleTextStyle: TextStyle(`n          fontSize: 18,`n          fontWeight: FontWeight.w600,`n          color: AppColors.darkTextPrimary,`n        ),`n        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),`n      ),"
        New = "      // AppBar Theme`n      appBarTheme: AppBarTheme(`n        centerTitle: true,`n        elevation: 0,`n        scrolledUnderElevation: 1,`n        backgroundColor: AppColors.darkSurface,`n        foregroundColor: AppColors.darkTextPrimary,`n        surfaceTintColor: Colors.transparent,`n        systemOverlayStyle: SystemUiOverlayStyle.light,`n        titleTextStyle: TextStyle(`n          fontSize: 18.sp,`n          fontWeight: FontWeight.w600,`n          color: AppColors.darkTextPrimary,`n        ),`n        iconTheme: IconThemeData(`n          color: AppColors.darkTextPrimary,`n          size: 24.r,`n        ),`n      ),"
    }
)

# Apply simple pattern-based replacements
$content = $content -replace "BorderRadius\.circular\((\d+)\)(?![.rs])", "BorderRadius.circular(`$1.r)"
$content = $content -replace "fontSize:\s*(\d+)(?![.rs])", "fontSize: `$1.sp"
$content = $content -replace "Size\.fromHeight\((\d+)\)(?![.rs])", "Size.fromHeight(`$1.r)"
$content = $content -replace "EdgeInsets\.symmetric\(horizontal:\s*(\d+),\s*vertical:\s*(\d+)\)(?![.rs])", "EdgeInsets.symmetric(horizontal: `$1.r, vertical: `$2.r)"
$content = $content -replace "EdgeInsets\.all\((\d+)\)(?![.rs])", "EdgeInsets.all(`$1.r)"
$content = $content -replace "BorderSide\(color:\s*([^,]+),\s*width:\s*(\d+(?:\.\d+)?)\)(?![.rs])", "BorderSide(color: `$1, width: `$2.r)"
$content = $content -replace "size:\s*(\d+)(?![.rs])", "size: `$1.r"
$content = $content -replace "thickness:\s*(\d+)(?![.rs])", "thickness: `$1.r"
$content = $content -replace "space:\s*(\d+)(?![.rs])", "space: `$1.r"
$content = $content -replace "Radius\.circular\((\d+)\)(?![.rs])", "Radius.circular(`$1.r)"

# Remove const where .r is used
$content = $content -replace "const EdgeInsets", "EdgeInsets"
$content = $content -replace "const Size", "Size"
$content = $content -replace "const AppBarTheme", "AppBarTheme"
$content = $content -replace "const IconThemeData", "IconThemeData"
$content = $content -replace "const TextStyle", "TextStyle"
$content = $content -replace "const FloatingActionButtonThemeData", "FloatingActionButtonThemeData"
$content = $content -replace "const DividerThemeData", "DividerThemeData"
$content = $content -replace "const BottomSheetThemeData", "BottomSheetThemeData"
$content = $content -replace "const BorderSide", "BorderSide"

Set-Content -Path $filePath -Value $content -NoNewline

Write-Host "Dark theme updated with responsive values!" -ForegroundColor Green
Write-Host "Running dart format..." -ForegroundColor Cyan
& dart format lib/core/theme/app_theme.dart
