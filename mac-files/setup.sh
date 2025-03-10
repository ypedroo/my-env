#!/bin/zsh

# Mac Setup Script
# Author: Ynoa Pedro
# Description: Automated setup script for macOS development environment
# Version: 1.0
# Last Updated: March 10, 2025

# Enable error handling
set -e

# Setup logging
LOG_FILE="$HOME/setup_$(date +%Y%m%d_%H%M%S).log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

# Check CPU architecture
if [[ $(uname -m) == "arm64" ]]; then
    ARCH="arm64"
else
    ARCH="x64"
fi

# Resume capability
RESUME_FILE="/tmp/setup_resume"
LAST_COMPLETED_STEP=""

if [ -f "$RESUME_FILE" ]; then
    read -p "Resume from last session? [y/N] " RESUME
    if [[ $RESUME =~ ^[Yy]$ ]]; then
        LAST_COMPLETED_STEP=$(cat "$RESUME_FILE")
        echo "Resuming after step: $LAST_COMPLETED_STEP"
    else
        rm "$RESUME_FILE"
    fi
fi

# Save progress function
save_progress() {
    echo "$1" > "$RESUME_FILE"
}

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        echo "Check the log file for details: $LOG_FILE"
        exit 1
    fi
    save_progress "$1"
}

# Function to install if not exists
install_if_not_exists() {
    local package=$1
    local type=$2
    if ! brew list $package &>/dev/null; then
        echo "Installing $package..."
        if [ "$type" = "cask" ]; then
            brew install --cask $package
        else
            brew install $package
        fi
        check_command "$package installation"
    else
        echo "$package is already installed, skipping..."
    fi
}

# Parse command-line arguments
INSTALL_GENERAL=true
INSTALL_DEV=true
INSTALL_COMM=true
INSTALL_SHELL=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-general)
            INSTALL_GENERAL=false
            shift
            ;;
        --no-dev)
            INSTALL_DEV=false
            shift
            ;;
        --no-comm)
            INSTALL_COMM=false
            shift
            ;;
        --no-shell)
            INSTALL_SHELL=false
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --no-general    Skip general tools installation"
            echo "  --no-dev        Skip development tools installation"
            echo "  --no-comm       Skip communication tools installation"
            echo "  --no-shell      Skip shell customization"
            echo "  --help          Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check for Homebrew, install if we don't have it
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_command "Homebrew installation"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

echo "Updating Homebrew..."
brew update
check_command "Homebrew update"

# Install required tools if missing
echo "\n=== Installing Required Tools ===\n"
for tool in curl git jq; do
    if ! command -v $tool &> /dev/null; then
        echo "Installing $tool..."
        brew install $tool
        check_command "$tool installation"
    else
        echo "$tool is already installed, skipping..."
    fi
done

# Verify all required tools are installed
for tool in curl git jq; do
    command -v $tool >/dev/null 2>&1 || { 
        echo "Error: Failed to install $tool" >&2
        exit 1
    }
done

# Verify all required tools are installed
for tool in curl git jq; do
    command -v $tool >/dev/null 2>&1 || { 
        echo "Error: Failed to install $tool" >&2
        exit 1
    }
done


# General Tools Installation
if [ "$INSTALL_GENERAL" = true ]; then
    echo "\n=== Installing General Tools ===\n"
    install_if_not_exists "microsoft-edge" "cask"
    install_if_not_exists "google-chrome" "cask"
    install_if_not_exists "spotify" "cask"
    install_if_not_exists "notion" "cask"
    install_if_not_exists "bitwarden" "cask"
    install_if_not_exists "btop"
    install_if_not_exists "ghostty"
    install_if_not_exists "raycast" "cask"
    install_if_not_exists "microsoft-outlook" "cask"
    install_if_not_exists "neofetch"
    install_if_not_exists "rectangle" "cask"
    install_if_not_exists "bartender" "cask"
    install_if_not_exists "obsidian" "cask"
    install_if_not_exists "windows-app" "cask"
    install_if_not_exists "lazydocker"
    install_if_not_exists "shottr" "cask"
fi

# Communication Tools Installation
if [ "$INSTALL_COMM" = true ]; then
    echo "\n=== Installing Communication Tools ===\n"
    install_if_not_exists "discord" "cask"
    install_if_not_exists "slack" "cask"
    install_if_not_exists "microsoft-teams" "cask"
fi

# Development Tools Installation
if [ "$INSTALL_DEV" = true ]; then
    echo "\n=== Installing Development Tools ===\n"
    
    # .NET SDK Installation
    echo "Installing .NET SDK..."
    RELEASES_JSON=$(curl -s https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json)
    check_command ".NET releases metadata download"

    DOTNET_LATEST_LTS=$(echo "$RELEASES_JSON" | jq -r '.["releases-index"][] | select(."release-type"=="lts" and ."support-phase"=="active") | ."channel-version"' | sort -rV | head -n1)
    [ -n "$DOTNET_LATEST_LTS" ] || { echo "Error: Could not determine latest .NET LTS version" >&2; exit 1; }

    echo "Found .NET SDK LTS version: ${DOTNET_LATEST_LTS}"

    RELEASE_JSON=$(curl -s "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/${DOTNET_LATEST_LTS}/releases.json")
    check_command ".NET version-specific metadata download"

    DOTNET_PKG_URL=$(echo "$RELEASE_JSON" | jq -r '.releases[0].sdk.files[] | select(.name | endswith("osx-'$ARCH'.pkg")) | .url')
    [ -n "$DOTNET_PKG_URL" ] || { echo "Error: Could not determine download URL" >&2; exit 1; }

    curl -L -o dotnet-sdk.pkg "$DOTNET_PKG_URL"
    check_command ".NET SDK download"

    sudo installer -pkg dotnet-sdk.pkg -target /
    check_command ".NET SDK installation"
    rm dotnet-sdk.pkg

    # Other Development Tools
    install_if_not_exists "nvm"
    install_if_not_exists "yarn"
    install_if_not_exists "jetbrains-toolbox" "cask"
    install_if_not_exists "visual-studio-code" "cask"
    install_if_not_exists "docker" "cask"
    install_if_not_exists "neovim"
    install_if_not_exists "postman" "cask"

    # AWS CLI Installation
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    check_command "AWS CLI installation"
    rm AWSCLIV2.pkg

    # Azure CLI Installation
    install_if_not_exists "azure-cli"
fi

# Shell Configuration
if [ "$INSTALL_SHELL" = true ]; then
    echo "\n=== Configuring Shell Environment ===\n"
    
    # Set zsh as default shell
    chsh -s $(which zsh)
    check_command "Setting zsh as default shell"

    # Install oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        check_command "oh-my-zsh installation"
    fi

    # Install powerlevel10k theme
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        check_command "powerlevel10k installation"
    fi

    # Install zsh plugins
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        check_command "zsh-autosuggestions installation"
    fi

    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        check_command "zsh-syntax-highlighting installation"
    fi

    # Backup and create new configs
    echo "Backing up existing configurations..."
    [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup-$(date +%Y%m%d)
    [ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.gitconfig.backup-$(date +%Y%m%d)

    # Create new zsh config
    echo "Setting up new zsh configuration..."
    cat << 'EOF' > ~/.zshrc
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    docker
    dotnet
    node
    npm
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/share/dotnet:$PATH"
export DOTNET_ROOT="/usr/local/share/dotnet"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

    # Create new git config
    echo "Setting up new git configuration..."
    cat << EOF > ~/.gitconfig
[user]
    name = Ynoa Pedro
    email = ynoa.pedro@outlook.com
[push]
    default = current
[filter "lfs"]
    smudge = git-lfs smudge -- %f
    process = git-lfs filter-process
    required = true
    clean = git-lfs clean -- %f
[core]
    editor = code --wait
[init]
    defaultBranch = main
EOF
fi

# Cleanup
echo "\n=== Cleaning up... ===\n"
brew cleanup
rm -f *.pkg *.tmp "$RESUME_FILE" 2>/dev/null

# Final message
echo "\n=== Setup Complete! ===\n"
echo "Setup completed successfully! Log file: $LOG_FILE"
echo "\nPlease restart your terminal to apply all changes."
echo "\nNext steps:"
echo "1. Configure Powerlevel10k: p10k configure"
echo "2. Set up your SSH keys for Git"
echo "3. Log in to your applications"
echo "4. Review the log file for any warnings: $LOG_FILE"
echo "\nWelcome back! 🚀"