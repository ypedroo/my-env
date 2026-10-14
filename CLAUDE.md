# CLAUDE.md

## Project Overview

This is a personal dotfiles repository for setting up development environments across different operating systems (primarily macOS and Linux). The repository contains installation scripts and configuration files for various development tools, applications, and shell customizations.

## Repository Structure

```
my-env/
├── dotfiles/               # Main configuration and installation scripts
│   ├── apps/              # Application-specific installation scripts
│   ├── scripts/           # Utility scripts for package management
│   └── profilesBackup/    # Backup copies of configuration files
├── mac-files/             # macOS-specific setup scripts
├── windows-dotfiles/      # Windows-specific configuration files
└── README.md              # Project documentation
```

## Key Components

### Application Installation Scripts ([dotfiles/apps/](dotfiles/apps/))
- [chrome.sh](dotfiles/apps/chrome.sh) - Google Chrome setup
- [docker.sh](dotfiles/apps/docker.sh) - Docker installation
- [dotnet.sh](dotfiles/apps/dotnet.sh) - .NET SDK installation (latest LTS)
- [nvm-npm-node-packages.sh](dotfiles/apps/nvm-npm-node-packages.sh) - Node.js via NVM
- [python.sh](dotfiles/apps/python.sh) - Python environment setup
- [yarn.sh](dotfiles/apps/yarn.sh) - Yarn package manager
- [zsh.sh](dotfiles/apps/zsh.sh) - ZSH shell with oh-my-zsh

### Utility Scripts ([dotfiles/scripts/](dotfiles/scripts/))
- [aptinstall.sh](dotfiles/scripts/aptinstall.sh) - APT package installation helper
- [snapInstall.sh](dotfiles/scripts/snapInstall.sh) - Snap package installation helper

### Main Setup Scripts
- [mac-files/setup.sh](mac-files/setup.sh) - macOS environment setup with resume capability
- [dotfiles/do_magic.sh](dotfiles/do_magic.sh) - Linux environment setup

### Windows Configuration
- [windows-dotfiles/ps-profile.ps1](windows-dotfiles/ps-profile.ps1) - PowerShell profile
- [windows-dotfiles/starship.toml](windows-dotfiles/starship.toml) - Starship prompt config
- [windows-dotfiles/terminal-profile.json](windows-dotfiles/terminal-profile.json) - Terminal settings

## Installation Options

The setup scripts support selective installation:

```bash
# macOS
./mac-files/setup.sh [--no-general] [--no-dev] [--no-comm] [--no-shell]

# Linux
./dotfiles/do_magic.sh
```

## Tool Categories

### General Tools
- Browsers: Chrome, Edge
- Productivity: Notion, Obsidian, Bitwarden, Raycast, Rectangle, Bartender
- Utilities: Neofetch, Btop, LazyDocker

### Development Tools
- IDEs/Editors: VS Code, Neovim, Zed, OpenCode, JetBrains Toolbox
- Runtimes: .NET LTS, Node.js (via NVM), Python
- Tools: Docker, Postman, Yarn

### Communication Tools
- Discord, Slack, Microsoft Teams

### Cloud Tools
- AWS CLI, Azure CLI

## Shell Configuration

- **Shell**: ZSH with oh-my-zsh framework
- **Theme**: Powerlevel10k
- **Plugins**: Autosuggestions, Syntax Highlighting

## Git Configuration

- Default branch: `main`
- Default editor: VSCode
- Git LFS enabled

## Development Guidelines

When working with this repository:

1. **Test Changes**: Always test setup scripts in a VM or clean environment before committing
2. **Backup Handling**: The scripts automatically backup existing configurations
3. **Resume Capability**: macOS setup script tracks progress and can resume after interruption
4. **Architecture Detection**: Scripts detect Apple Silicon vs Intel for macOS
5. **Logging**: All operations are logged to `~/setup_YYYYMMDD_HHMMSS.log`

## Common Tasks

- **Adding new tools**: Create scripts in appropriate `apps/` subdirectory
- **Updating configurations**: Modify files in `dotfiles/` or platform-specific directories
- **Testing changes**: Use the selective installation flags to test specific components

## Platform-Specific Notes

### macOS
- Uses Homebrew for package management
- Supports both Intel and Apple Silicon architectures
- Requires manual permission grant for some tools

### Linux
- Uses APT and Snap package managers
- Tested on Ubuntu-based distributions

### Windows
- PowerShell-based configuration
- Starship prompt for cross-platform consistency
