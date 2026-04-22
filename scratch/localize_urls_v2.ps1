
$root = "d:\Website\Rang the House of beauty"
$files = Get-ChildItem $root -Recurse -Include "*.html","*.css"

foreach ($file in $files) {
    if ($file.Attributes -match "Directory") { continue }
    Write-Host "Localizing: $($file.FullName)"
    $content = Get-Content $file.FullName -Raw
    if ($null -eq $content) { continue }
    
    # Regex to match Squarespace CDN URLs with or without protocol
    # Matches: https://..., http://..., //..., and even plain images.squarespace-cdn.com/
    $pattern = '(?:https?:)?//(?:images|static1|assets|definitions)\.squarespace(?:-cdn)?\.com/'
    
    $newContent = [regex]::Replace($content, $pattern, './$0')
    
    # Cleanup: if we added ./ to something that already had it, or if we ended up with .///, etc.
    # Actually, a better approach is to match the domains directly and replace with local paths.
    
    $domains = @("images.squarespace-cdn.com", "static1.squarespace.com", "assets.squarespace.com", "definitions.sqspcdn.com")
    $newContent = $content
    foreach ($domain in $domains) {
        # Match any variant of the domain reference
        # 1. https://domain/
        # 2. http://domain/
        # 3. //domain/
        # 4. "domain/ (common in data-src)
        
        $newContent = $newContent -replace "https://$domain/", "./$domain/"
        $newContent = $newContent -replace "http://$domain/", "./$domain/"
        $newContent = $newContent -replace "//$domain/", "./$domain/"
        # Handle cases where it's already localized but missing the ./ (e.g. data-src="images.squarespace-cdn.com/...")
        # We look for the domain preceded by a quote or space and NOT preceded by ./
        $newContent = [regex]::Replace($newContent, "(?<=[\""\s])(?!\./)$domain/", "./$domain/")
    }

    if ($content -ne $newContent) {
        Set-Content $file.FullName $newContent -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
