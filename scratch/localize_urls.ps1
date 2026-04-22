
$root = "d:\Website\Rang the House of beauty"
$files = Get-ChildItem $root -Recurse -Include "*.html","*.css"

foreach ($file in $files) {
    if ($file.Attributes -match "Directory") { continue }
    Write-Host "Localizing: $($file.FullName)"
    $content = Get-Content $file.FullName -Raw
    if ($null -eq $content) { continue }
    
    $newContent = $content
    
    # Replace absolute URLs with local directory paths
    $newContent = $newContent -replace "https://images.squarespace-cdn.com/", "./images.squarespace-cdn.com/"
    $newContent = $newContent -replace "https://static1.squarespace.com/", "./static1.squarespace.com/"
    $newContent = $newContent -replace "https://assets.squarespace.com/", "./assets.squarespace.com/"
    $newContent = $newContent -replace "https://definitions.sqspcdn.com/", "./definitions.sqspcdn.com/"
    
    # Handle protocol-relative URLs (//images.squarespace-cdn.com/...)
    $newContent = $newContent -replace "//images.squarespace-cdn.com/", "./images.squarespace-cdn.com/"
    $newContent = $newContent -replace "//static1.squarespace.com/", "./static1.squarespace.com/"
    $newContent = $newContent -replace "//assets.squarespace.com/", "./assets.squarespace.com/"
    
    if ($content -ne $newContent) {
        Set-Content $file.FullName $newContent -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
