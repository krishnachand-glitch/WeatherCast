# Auto-installer & APK Builder for WeatherCast Pro
# Monitors C:\Users\Dell\Downloads for completed Flutter zip, extracts, and builds APK

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   WeatherCast Pro - Automated Flutter & APK Builder" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$downloadDir = "C:\Users\Dell\Downloads"
$extractTarget = "C:\src"
$flutterBin = "C:\src\flutter\bin"
$projectDir = "C:\Users\Dell\Desktop\HoneyChain\weathercast_pro"

# Step 1: Wait for download completion
Write-Host "[1/4] Monitoring download in $downloadDir..." -ForegroundColor Yellow

while ($true) {
    # Check if active .crdownload exists
    $active = Get-ChildItem -Path "$downloadDir\*.crdownload" -ErrorAction SilentlyContinue | 
              Sort-Object Length -Descending | Select-Object -First 1

    # Check if completed flutter zip exists
    $completedZip = Get-ChildItem -Path "$downloadDir" -Filter "*flutter*.zip" -ErrorAction SilentlyContinue |
                    Select-Object -First 1

    if ($completedZip -and -not $active) {
        Write-Host "Found completed Flutter zip: $($completedZip.FullName)" -ForegroundColor Green
        $targetZip = $completedZip.FullName
        break
    }

    if ($active) {
        $mb = [math]::Round($active.Length / 1MB, 2)
        $pct = [math]::Round(($active.Length / 1150MB) * 100, 1)
        Write-Host -NoNewline "`rDownloading Flutter: $mb MB / ~1150 MB ($pct%) ... "
    } else {
        Write-Host -NoNewline "`rWaiting for download to begin or finish... "
    }

    Start-Sleep -Seconds 5
}

Write-Host ""
Write-Host "[2/4] Fast extracting Flutter SDK with tar.exe to $extractTarget..." -ForegroundColor Yellow
if (-not (Test-Path $extractTarget)) {
    New-Item -ItemType Directory -Path $extractTarget -Force | Out-Null
}

tar.exe -xf $targetZip -C $extractTarget
Write-Host "Extraction complete: $extractTarget\flutter" -ForegroundColor Green

# Step 3: Add to User PATH if not already present
Write-Host "[3/4] Configuring Environment PATH..." -ForegroundColor Yellow
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$flutterBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$flutterBin", "User")
    Write-Host "Added $flutterBin to User PATH." -ForegroundColor Green
}
$env:Path = "$flutterBin;$env:Path"

# Step 4: Run APK Build
Write-Host "[4/4] Launching APK Build..." -ForegroundColor Yellow
Set-Location $projectDir
& "$projectDir\build_apk.bat"
