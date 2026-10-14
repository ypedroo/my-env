# 👋 Welcome to my Dotfiles!

These are the base dotfiles that I start with when I set up a new environment. Over the years, I've assembled a collection of useful tools and configurations that speed up my workflow and make system tasks more enjoyable.

## 📝 What's Inside?

A whole bunch of awesome daily drivers for me! Here's a list:

- 🌐 General Tools
  - Microsoft Edge
  - Google Chrome
  - Spotify
  - Notion
  - Bitwarden
  - Neofetch
  - Btop
  - Rectangle
  - Raycast
  - Thaw
  - Obsidian
  - Windows App
  - LazyDocker

- 📞 Communication Tools
  - Discord
  - Slack
  - Microsoft Teams

- 💻 Development Tools
  - .NET (Latest LTS version)
  - Node Version Manager (NVM)
  - Yarn
  - JetBrains Toolbox
  - Visual Studio Code
  - OrbStack
  - Neovim
  - Zed
  - Postman
  - OpenCode

- ☁️ Cloud Tools
  - AWS CLI
  - Azure CLI

- 🐚 Shell Configurations
  - ZSH with oh-my-zsh
  - Powerlevel10k theme
  - ZSH Autosuggestions
  - ZSH Syntax Highlighting

- ⚙️ Git Configuration
  - Optional user identity setup
  - LFS configuration
  - VSCode as default editor
  - Main as default branch

## 🚀 Quick Start

### macOS Installation Options

The setup script supports several installation options:

```bash
./mac-files/setup.sh [options]

Options:
  --no-general    Skip general tools installation
  --no-dev        Skip development tools installation
  --no-comm       Skip communication tools installation
  --no-shell      Skip shell customization
  --non-interactive Use defaults without prompting
  --reset         Clear saved progress before starting
  --help          Show this help message
```

### macOS Setup

1. Clone this repository:
    ```bash
    git clone https://github.com/ypedroo/my-env.git
    ```

2. Navigate to the repository:
    ```bash
    cd my-env
    ```

3. Make the macOS setup script executable:
    ```bash
    chmod +x mac-files/setup.sh
    ```

4. Run the setup script (choose one):
    ```bash
    # Full installation
    ./mac-files/setup.sh
    
    # Skip general tools
    ./mac-files/setup.sh --no-general
    
    # Skip development tools
    ./mac-files/setup.sh --no-dev
    
    # Show all options
    ./mac-files/setup.sh --help
    ```

## 📋 Features

- ✅ Repeatable installation of the selected tools
- ✅ Smart .NET SDK installation (latest LTS version)
- ✅ Progress tracking and resume capability
- ✅ Comprehensive logging
- ✅ Selective installation options
- ✅ Timestamped backup of an existing `.zshrc`
- ✅ Existing `.gitconfig` settings are preserved
- ✅ Architecture detection (Apple Silicon/Intel)

The macOS catalog installs OrbStack for container workflows and Thaw as the
menu-bar utility. It does not install Docker Desktop or Bartender.

## 📝 Post-Installation

After running the script:

1. Restart your terminal to apply all changes
2. Configure Powerlevel10k: `p10k configure`
3. Set up your SSH keys for Git
4. Log in to your applications
5. Review the log file for any warnings (location shown after setup)

## 🔄 Resume Capability

If the script is interrupted, run it again and confirm the resume prompt. Progress
is stored under `~/Library/Application Support/mac-setup/`. Use `--reset` to
discard the saved checkpoint and start over.

Git identity is not changed unless both of these environment variables are set:

```bash
GIT_USER_NAME="Your Name" GIT_USER_EMAIL="you@example.com" ./mac-files/setup.sh
```

## ⚠️ Disclaimer

Please review the setup scripts before running them. I am not responsible for any unforeseen consequences of running these scripts on your system.
Also this is a personal setup feel free to fork it and use it as will.

## 📑 Logs

The script creates detailed logs in your home directory. After installation, you can find them at:
```bash
~/setup_YYYYMMDD_HHMMSS.log
```

### Other Systems Setup

1. Clone this repository:
    ```bash
    git clone https://github.com/ypedroo/my-env.git
    ```

2. Navigate to the repository:
    ```bash
    cd my-env
    ```

3. Make the setup script executable:
    ```bash
    chmod +x setup.sh
    ```

4. Run the setup script:
    ```bash
    ./setup.sh
    ```

Enjoy your new environment! 🎉
