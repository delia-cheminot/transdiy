#!/bin/bash
set -e

echo -e "Preparing local repository for development...\n"

if ! command -v dart &> /dev/null; then
    echo -e "Error: Dart is not installed or not in your PATH.\n"
    echo "FVM requires Dart to be installed initially.\n - Please install Flutter globally first.\n - If Flutter is install check 'flutter doctor' for more informations.\n"
    exit 1
fi

PUB_CACHE_BIN="$HOME/.pub-cache/bin"

if ! command -v fvm &> /dev/null; then
    echo -e "FVM not found. Installing the latest FVM via Dart pub..."
    dart pub global activate fvm > /dev/null
else
    echo -e "FVM is already installed on this machine."
    dart pub global activate fvm > /dev/null
fi

echo -e "\nChecking shell environment variables..."

add_to_profile() {
    local profile_file=$1
    if [ -f "$profile_file" ]; then
        if ! grep -q "$PUB_CACHE_BIN" "$profile_file"; then
            echo -e "\n# Add Dart Pub Cache for FVM\n$PATH_EXPORT_CMD" >> "$profile_file"
            echo -e "  ↳ Added FVM to $profile_file"
        else
            echo -e "  ↳ FVM path already exists in $profile_file"
        fi
    fi
}

add_to_profile "$HOME/.bashrc"
add_to_profile "$HOME/.bash_profile"
add_to_profile "$HOME/.zshrc"

FISH_PROFILE="$HOME/.config/fish/config.fish"
if [ -f "$FISH_PROFILE" ]; then
    if ! grep -q "$PUB_CACHE_BIN" "$FISH_PROFILE"; then
        echo -e "\n# Add Dart Pub Cache for FVM\nfish_add_path $PUB_CACHE_BIN" >> "$FISH_PROFILE"
        echo -e "  ↳ Added FVM to $FISH_PROFILE"
    else
        echo -e "  ↳ FVM path already exists in $FISH_PROFILE"
    fi
fi

export PATH="$PATH:$PUB_CACHE_BIN"

echo -e "\nConfiguring project to use the latest stable Flutter SDK..."
fvm use stable

echo -e "\nFetching the latest dependencies..."
fvm flutter pub get

echo -e "\nSetup complete! The repository is ready for development."
echo -e "Important: You may need to restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) for the 'fvm' command to be available globally."
