#!/bin/zsh

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

echo "Installing Development Tools..."
echo "Installing .NET SDK..."

# Download and parse the releases index with proper error handling
RELEASES_JSON=$(curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json)
if [ $? -ne 0 ]; then
    echo "Error: Failed to download .NET releases metadata"
    exit 1
fi

# Get latest active LTS version
DOTNET_LATEST_LTS=$(echo "$RELEASES_JSON" | jq -r '.["releases-index"][] | select(."release-type"=="lts" and ."support-phase"=="active") | ."channel-version"' | sort -rV | head -n1)
if [ -z "$DOTNET_LATEST_LTS" ]; then
    echo "Error: Could not determine latest .NET LTS version"
    exit 1
fi

echo "Found .NET SDK LTS version: ${DOTNET_LATEST_LTS}"

# Get the download URL for the latest LTS version
RELEASE_JSON=$(curl -s "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/${DOTNET_LATEST_LTS}/releases.json")
if [ $? -ne 0 ]; then
    echo "Error: Failed to download version-specific release metadata"
    exit 1
fi

DOTNET_PKG_URL=$(echo "$RELEASE_JSON" | jq -r '.releases[0].sdk.files[] | select(.name | endswith("osx-arm64.pkg")) | .url')
if [ -z "$DOTNET_PKG_URL" ]; then
    echo "Error: Could not determine download URL"
    exit 1
fi

echo "Downloading .NET SDK LTS version ${DOTNET_LATEST_LTS}..."
curl -L -o dotnet-sdk.pkg "$DOTNET_PKG_URL"
check_command ".NET SDK download"

echo "Installing .NET SDK..."
sudo installer -pkg dotnet-sdk.pkg -target /
check_command ".NET SDK installation"

# Cleanup
rm dotnet-sdk.pkg

# Add .NET to PATH in .zshrc if not already present
if ! grep -q "DOTNET_ROOT" ~/.zshrc; then
    echo 'export PATH="/usr/local/share/dotnet:$PATH"' >> ~/.zshrc
    echo 'export DOTNET_ROOT="/usr/local/share/dotnet"' >> ~/.zshrc
fi

