
$root = "d:\Website\Rang the House of beauty"
$csvPath = "$root\scratch\unique_image_urls_v2.csv"
$urls = Import-Csv $csvPath

if (-not (Test-Path "$root\images.squarespace-cdn.com")) { New-Item -ItemType Directory -Path "$root\images.squarespace-cdn.com" }
if (-not (Test-Path "$root\static1.squarespace.com")) { New-Item -ItemType Directory -Path "$root\static1.squarespace.com" }
if (-not (Test-Path "$root\assets.squarespace.com")) { New-Item -ItemType Directory -Path "$root\assets.squarespace.com" }

foreach ($row in $urls) {
    $url = $row.Url
    $uri = [URI]$url
    $hostDir = $uri.Host
    $localRelativePath = $uri.AbsolutePath.TrimStart('/')
    $localFullPath = Join-Path (Join-Path $root $hostDir) $localRelativePath
    
    $parentDir = [System.IO.Path]::GetDirectoryName($localFullPath)
    if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Path $parentDir -Force }
    
    if (Test-Path $localFullPath) {
        Write-Host "Skipping (exists): $url"
        continue
    }
    
    Write-Host "Downloading: $url -> $localFullPath"
    try {
        Invoke-WebRequest -Uri $url -OutFile $localFullPath -ErrorAction Stop
    } catch {
        Write-Error "Failed to download ${url}: $($_.Exception.Message)"
    }
}
