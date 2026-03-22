Write-Host "Preparing local repository for development...`n" -ForegroundColor Magenta;

$dart = Get-Command dart -ErrorAction SilentlyContinue;

if (!$dart) {
    Write-Host @"
Error: Dart is not installed or not in your PATH
FVM requires Dart to be installed initially.
 - Please install Flutter globally first.
 - If Flutter is installed, check 'flutter doctor' for more information.
"@ -ForegroundColor Red;
    exit 1;
}

$fvm = Get-Command fvm -ErrorAction SilentlyContinue;

if (!$fvm) {
    Write-Host "FVM not found. Installing the latest FVM via Dart pub..." -ForegroundColor Yellow;
    & dart pub global activate fvm | Out-Null;
} else {
    Write-Host "FVM is already installed." -ForegroundColor Green;
}
Write-Host "`nChecking user path for pub cache..." -ForegroundColor Magenta;

$PUB_CACHE_BIN = "$env:LOCALAPPDATA\Pub\cache\bin";

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User");

if ([string]::IsNullOrEmpty($currentPath)) {
    throw 'Failed to retrieve user path.';
    exit 1;
}

if($currentPath.Split(";") -contains $PUB_CACHE_BIN) {
    Write-Host "`nPub cache folder already in user path." -ForegroundColor Green;
} else {
    # Update path for user
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$PUB_CACHE_BIN", "User");

    # Update path for the current shell
    $env:Path = "$env:Path;$PUB_CACHE_BIN";

    Write-Host "`nPub cache folder added to user path !" -ForegroundColor Green;
}

Write-Host "`nConfiguring project to use the correct Flutter SDK...`n" -ForegroundColor Magenta;
& fvm use 3.41.5;

Write-Host "`nFetching the latest dependencies...`n" -ForegroundColor Magenta;
& fvm flutter pub get;

Write-Host "`nSetup complete! The repository is ready for development." -ForegroundColor Green;
Write-Host "You may need to restart your terminal for the 'fvm' command to be available globally." -ForegroundColor Yellow;
