#!/bin/zsh

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Check for Homebrew, install if we don't have it
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_command "Homebrew installation"
fi

echo "Updating Homebrew..."
brew update
check_command "Homebrew update"

echo "Installing General Tools..."
brew install --cask microsoft-edge
check_command "Microsoft Edge installation"
brew install --cask google-chrome
check_command "Google Chrome installation"
brew install --cask spotify
check_command "Spotify installation"
brew install --cask notion
check_command "Notion installation"
brew install --cask bitwarden
check_command "Bitwarden installation"
brew install btop
check_command "btop installation"
brew install ghostty
check_command "Ghostty installation"
brew install --cask raycast
check_command "Raycast installation"
brew install --cask microsoft-outlook
check_command "Microsoft Outlook installation"
brew install neofetch
check_command "Neofetch installation"
brew install --cask rectangle
check_command "Rectangle installation"
brew install --cask bartender
check_command "Bartender installation"
brew install --cask obsidian
check_command "Obsidian installation"
brew install --cask windows-app
check_command "Windows App installation"
brew install lazydocker
check_command "Lazydocker installation"


echo "Installing Communication Tools..."
brew install --cask discord
check_command "Discord installation"
brew install --cask slack
check_command "Slack installation"
brew install --cask microsoft-teams
check_command "Microsoft Teams installation"

echo "Installing Development Tools..."
brew install --cask dotnet
check_command "dotnet installation"
brew install --cask dotnet-sdk
check_command "dotnet-sdk installation"
brew install nvm
check_command "nvm installation"
brew install yarn
check_command "yarn installation"
brew install --cask jetbrains-toolbox
check_command "JetBrains Toolbox installation"
brew install --cask visual-studio-code
check_command "Visual Studio Code installation"
brew install --cask docker
check_command "Docker installation"
brew install neovim
check_command "Neovim installation"
brew install --cask postman
check_command "Postman installation"

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
check_command "AWS CLI download"
sudo installer -pkg AWSCLIV2.pkg -target /
check_command "AWS CLI installation"
rm AWSCLIV2.pkg

# Install Azure CLI
echo "Installing Azure CLI..."
brew install azure-cli
check_command "Azure CLI installation"

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
check_command "oh-my-zsh installation"

echo "Installing powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
check_command "powerlevel10k installation"

echo "Installing zsh-autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
check_command "zsh-autosuggestions installation"

echo "Installing zsh-syntax-highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
check_command "zsh-syntax-highlighting installation"

echo "Backing up existing zsh config..."
mv ~/.zshrc ~/.zshrc.backup

echo "Setting up zsh config..."
cat << EOF > ~/.zshrc
# Add your zsh config here
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh" ]]; then
  source "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh"
fi

# Your zsh config continues here...
EOF

echo "Backing up existing git config..."
mv ~/.gitconfig ~/.gitconfig.backup

echo "Setting up git config..."
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
EOF

echo "Welcome back! 🚀"