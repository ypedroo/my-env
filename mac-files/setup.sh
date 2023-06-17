#!/bin/zsh

# Check for Homebrew, install if we don't have it
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Updating Homebrew..."
brew update

echo "Installing General Tools..."
brew install --cask microsoft-edge
brew install --cask google-chrome
brew install --cask spotify
brew install --cask notion
brew install --cask bitwarden
brew install neofetch
brew install btop

echo "Installing Communication Tools..."
brew install --cask discord
brew install --cask slack
brew install --cask microsoft-teams
brew install --cask skype

echo "Installing Development Tools..."
brew install --cask dotnet
brew install nvm
brew install yarn
brew install --cask jetbrains-toolbox
brew install --cask visual-studio-code
brew install --cask docker

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
rm AWSCLIV2.pkg

# Install Azure CLI
echo "Installing Azure CLI..."
brew install azure-cli

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Installing zsh-autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Installing zsh-syntax-highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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

echo "Done!"
