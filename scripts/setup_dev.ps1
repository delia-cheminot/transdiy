Write-Host "Preparing local repository for development...`n" -ForegroundColor Magenta;

$dart = Get-Command dart -ErrorAction SilentlyContinue;

if (!$dart) {
    Write-Host "Installing dart...`n" -ForegroundColor Magenta;

    $winget = Get-Command winget -ErrorAction SilentlyContinue;
    $chocolatey = Get-Command chocolatey -ErrorAction SilentlyContinue;
    $scoop = Get-Command scoop -ErrorAction SilentlyContinue;

    if($winget) {
        & winget install -e --id Google.DartSDK
    } elseIf ($scoop){
        & scoop bucket rm main
        & scoop bucket add main
        & scoop install main/dart
    } elseIf ($chocolatey) {
        & Start-Process powershell -Verb RunAs -ArgumentList "-Command choco install dart-sdk -y"
    } else {
        Write-Host @"
Error: Dart is not installed or not in your PATH
FVM requires Dart to be installed initially.
 - Please install Flutter or the Dart SDK globally first.
 - If Flutter is installed, check 'flutter doctor' for more information.
"@ -ForegroundColor Red;
        exit 1;
    }

    # Refresh path for dart to work
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User");

    $dartPostInstall = Get-Command dart -ErrorAction SilentlyContinue;

    if($dartPostInstall) {
        Write-Host "Dart installed successfully !" -ForegroundColor Green;
    } else {
        Write-Host @"
Error: Dart automatic installation failed.
A manual installation of the Dart SDK or Flutter is required.
FVM requires Dart to be installed initially.
 - Please install Flutter or the Dart SDK globally first.
 - If Flutter is installed, check 'flutter doctor' for more information.
"@ -ForegroundColor Red;
        exit 1;
    }
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
