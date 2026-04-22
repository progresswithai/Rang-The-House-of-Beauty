
$root = "d:\Website\Rang the House of beauty"
$files = Get-ChildItem $root -Recurse -Include "*.html","*.css"

# Domains to localize
$domains = @(
    "images.squarespace-cdn.com",
    "static1.squarespace.com",
    "assets.squarespace.com",
    "definitions.sqspcdn.com"
)

foreach ($file in $files) {
    if ($file.Attributes -match "Directory") { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $newContent = $content

    foreach ($domain in $domains) {
        # Escape domain for regex
        $escapedDomain = [regex]::Escape($domain)
        
        # 1. Match with protocol: http://domain/, https://domain/, //domain/
        # Replace with ./domain/
        $pattern1 = "(?:https?:)?//$escapedDomain/"
        $newContent = [regex]::Replace($newContent, $pattern1, "./$domain/")
        
        # 2. Match domain standing alone (no protocol) but potentially in a path
        # Example: data-src="images.squarespace-cdn.com/..."
        # We replace it with ./domain/ if it's not already preceded by ./
        $pattern2 = "(?<!\./)$escapedDomain/"
        $newContent = [regex]::Replace($newContent, $pattern2, "./$domain/")
    }

    # Final cleanup of double ././ or .//
    $newContent = $newContent -replace "\./\./", "./"
    $newContent = $newContent -replace "\./\./", "./" # Twice just in case
    
    if ($content -ne $newContent) {
        [System.IO.File]::WriteAllText($file.FullName, $newContent)
        Write-Host "Localized: $($file.Name)"
    }
}
