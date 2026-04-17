
$files = Get-ChildItem -Path . -Filter *.html -File

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # 1. Domain replace
    $content = $content -replace 'https://www.altitudesalonllc.com', 'https://rangthehouseofbeauty.com'
    $content = $content -replace 'altitudesalonllc.com', 'rangthehouseofbeauty.com'
    
    # 2. Brand Name replace (Lone Tree variation)
    $content = $content -replace 'Altitude Salon - Lone Tree, CO', 'Rang the House of Beauty'
    $content = $content -replace 'Altitude Salon', 'Rang the House of Beauty'
    
    # 3. Address Title in JSON
    $content = $content -replace '&quot;addressTitle&quot;:&quot;Altitude Salon&quot;', '&quot;addressTitle&quot;:&quot;Rang the House of Beauty&quot;'
    
    # 4. Images - Logos and Submarks
    # Generic replacement for squarespace cdn patterns that match Altitude logos
    $content = $content -replace 'images.squarespace-cdn.com/content/v1/66e34c24d6049d20d04964d1/[^"]+Altitude_(logo|submark)[^"]+', 'logo.png'
    $content = $content -replace '\.\./images.squarespace-cdn.com/content/v1/66e34c24d6049d20d04964d1/[^"]+Altitude_(logo|submark)[^"]+', 'logo.png'
    
    # 5. HTTrack Comment
    $content = $content -replace '<!-- Mirrored from www.altitudesalonllc.com/ by HTTrack', '<!-- Rebranded for Rang the House of Beauty from altitudesalonllc.com by'
    
    # 6. Remove Facebook social links (as per user request: "remove other")
    # This is trickier, we'll look for social accounts array in SQUARESPACE_CONTEXT
    $content = $content -replace '\{"serviceId":60,"screenname":"Facebook"[^\}]+\},?', ''
    # And the SVGs
    $content = $content -replace '<a[^>]+href="[^"]+facebook\.com[^"]+"[^>]*>.*?</a>', ''
    
    # 7. Update description meta tags if they still mention Altitude
    $content = $content -replace 'Altitude Salon in Lone Tree, CO', 'Rang the House of Beauty'
    
    Set-Content $file.FullName $content -NoNewline
}
