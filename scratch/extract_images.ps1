
$htmlFiles = Get-ChildItem "d:\Website\Rang the House of beauty" -Filter "*.html"
$imageUrls = @()

foreach ($file in $htmlFiles) {
    # Match https://images.squarespace-cdn.com/... or images.squarespace-cdn.com/...
    $content = Get-Content $file.FullName -Raw
    $matches = [regex]::Matches($content, '(?:"|h)ttps?://images\.squarespace-cdn\.com/[^"''? >]+|(?:"|h)ttps?://static1\.squarespace\.com/[^"''? >]+|(?:"|h)ttps?://assets\.squarespace\.com/[^"''? >]+')
    foreach ($m in $matches) {
        $url = $m.Value.Trim('"')
        if ($url -notlike "h*") { $url = "h" + $url } # Fix if it matched "ttps"
        $imageUrls += [PSCustomObject]@{
            File = $file.Name
            Url = $url
        }
    }
}

$uniqueUrls = $imageUrls | Group-Object Url | ForEach-Object {
    [PSCustomObject]@{
        Url = $_.Name
        Files = ($_.Group.File | Select-Object -Unique) -join ", "
    }
}

$uniqueUrls | Export-Csv -Path "d:\Website\Rang the House of beauty\scratch\image_urls.csv" -NoTypeInformation
$uniqueUrls | Measure-Object | Out-File "d:\Website\Rang the House of beauty\scratch\image_count.txt"
