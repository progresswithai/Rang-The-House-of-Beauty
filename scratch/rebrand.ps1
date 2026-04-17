
$files = Get-ChildItem -Path . -Filter *.html -File

$newName = "Rang"
$newFullName = "Rang - The House of Beauty"

foreach ($file in $files) {
    if ($file.Name -eq "rebrand.ps1") { continue }
    $content = Get-Content $file.FullName -Raw
    
    # 1. Generic replacement for Altitude in text (case insensitive)
    # We use regex with word boundaries to avoid partial matches if any
    $content = [regex]::Replace($content, '\bAltitude\b', $newName)
    
    # 2. Specifically handle the Aveda/Amazon links in shopaveda.html if they have altitude
    $content = $content -replace 'altitudesalon1', "rangsalon1"
    $content = $content -replace 'altitudesalon', "rangsalon"
    
    # 3. Handle the reviews script domain
    $content = $content -replace 'altitude\.aurasalonware\.com', "rang\.aurasalonware\.com"
    
    Set-Content $file.FullName $content -NoNewline
}
