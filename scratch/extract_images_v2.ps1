
$files = Get-ChildItem "d:\Website\Rang the House of beauty" -Recurse -Include "*.html","*.css"
$imageUrls = @()
foreach ($file in $files) {
    if ($file.Attributes -match "Directory") { continue }
    try {
        $content = Get-Content $file.FullName -Raw
        if ($null -eq $content) { continue }
        # Match base URLs but clean the suffix
        $matches = [regex]::Matches($content, 'https?://(images|static1|assets)\.squarespace-cdn\.com/[^"''? >\)\r\n\\&;,]+')
        foreach ($m in $matches) {
            $url = $m.Value
            # Basic cleanup of common trail characters
            $url = $url -replace '"$', '' -replace ',$', '' -replace "’$", ''
            $imageUrls += [PSCustomObject]@{ File = $file.FullName; Url = $url }
        }
    } catch {
        # Skip errors
    }
}
$uniqueUrls = $imageUrls | Select-Object -Unique Url
$uniqueUrls | Export-Csv -Path "d:\Website\Rang the House of beauty\scratch\unique_image_urls_v2.csv" -NoTypeInformation
Write-Host "Unique URLs found: $($uniqueUrls.Count)"
