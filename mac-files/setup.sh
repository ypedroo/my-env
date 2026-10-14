#!/bin/zsh

# Mac Setup Script
# Author: Ynoa Pedro
# Description: Automated setup script for a macOS development environment
# Version: 1.2.0
# Last Updated: October 14, 2026

set -euo pipefail

SCRIPT_NAME="mac-setup"
LOG_FILE="$HOME/setup_$(date +%Y%m%d_%H%M%S).log"
STATE_DIR="$HOME/Library/Application Support/$SCRIPT_NAME"
STATE_FILE="$STATE_DIR/state"
TMP_DIR=""

exec > >(tee -a "$LOG_FILE") 2>&1

die() {
    echo "Error: $1" >&2
    echo "Check the log file for details: $LOG_FILE" >&2
    exit 1
}

usage() {
    cat <<'EOF'
Usage: ./mac-files/setup.sh [options]

Options:
  --no-general       Skip general tools
  --no-dev           Skip development tools
  --no-comm          Skip communication tools
  --no-shell         Skip shell configuration
  --non-interactive  Use the selected/default options without prompting
  --reset            Clear saved progress before starting
  --help             Show this help
EOF
}

mkdir -p "$STATE_DIR"

INSTALL_GENERAL=true
INSTALL_DEV=true
INSTALL_COMM=true
INSTALL_SHELL=true
NON_INTERACTIVE=false
RESET_STATE=false
MENU_ENABLED=true

for arg in "$@"; do
    case "$arg" in
        --no-general) INSTALL_GENERAL=false; MENU_ENABLED=false ;;
        --no-dev) INSTALL_DEV=false; MENU_ENABLED=false ;;
        --no-comm) INSTALL_COMM=false; MENU_ENABLED=false ;;
        --no-shell) INSTALL_SHELL=false; MENU_ENABLED=false ;;
        --non-interactive) NON_INTERACTIVE=true; MENU_ENABLED=false ;;
        --reset) RESET_STATE=true ;;
        --help|-h) usage; exit 0 ;;
        *) die "Unknown option: $arg" ;;
    esac
done

if [[ "$RESET_STATE" == true ]]; then
    rm -f "$STATE_FILE"
fi

LAST_COMPLETED_STEP=0
if [[ -f "$STATE_FILE" ]]; then
    IFS='|' read -r LAST_COMPLETED_STEP SAVED_GENERAL SAVED_DEV SAVED_COMM SAVED_SHELL < "$STATE_FILE"
    RESUME=""
    if [[ "$NON_INTERACTIVE" != true && -t 0 ]]; then
        read -r "?Resume after step $LAST_COMPLETED_STEP? [y/N] " RESUME
        if [[ "$RESUME" =~ ^[Yy]$ ]]; then
            INSTALL_GENERAL="$SAVED_GENERAL"
            INSTALL_DEV="$SAVED_DEV"
            INSTALL_COMM="$SAVED_COMM"
            INSTALL_SHELL="$SAVED_SHELL"
            echo "Resuming after step $LAST_COMPLETED_STEP"
        else
            LAST_COMPLETED_STEP=0
            rm -f "$STATE_FILE"
        fi
    else
        INSTALL_GENERAL="$SAVED_GENERAL"
        INSTALL_DEV="$SAVED_DEV"
        INSTALL_COMM="$SAVED_COMM"
        INSTALL_SHELL="$SAVED_SHELL"
        echo "Resuming after step $LAST_COMPLETED_STEP"
    fi
fi

save_progress() {
    local step="$1"
    local temp_state="$STATE_FILE.tmp.$$"
    print -r -- "$step|$INSTALL_GENERAL|$INSTALL_DEV|$INSTALL_COMM|$INSTALL_SHELL" > "$temp_state"
    mv -f "$temp_state" "$STATE_FILE"
}

should_run() {
    (( LAST_COMPLETED_STEP < $1 ))
}

brew_is_installed() {
    local package="$1"
    local type="${2:-formula}"
    if [[ "$type" == cask ]]; then
        brew list --cask --versions "$package" >/dev/null 2>&1
    else
        brew list --formula --versions "$package" >/dev/null 2>&1
    fi
}

install_if_not_exists() {
    local package="$1"
    local type="${2:-formula}"

    if brew_is_installed "$package" "$type"; then
        echo "$package is already installed"
        return 0
    fi

    echo "Installing $package..."
    if [[ "$type" == cask ]]; then
        if command -v gum >/dev/null 2>&1; then
            gum spin --spinner dot --title "Installing $package..." -- brew install --cask "$package"
        else
            brew install --cask "$package"
        fi
    else
        if command -v gum >/dev/null 2>&1; then
            gum spin --spinner dot --title "Installing $package..." -- brew install "$package"
        else
            brew install "$package"
        fi
    fi
}

ensure_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is not installed. Installing it now..."
        /bin/bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
            || die "Homebrew installation"
    fi

    local brew_bin
    brew_bin="$(command -v brew || true)"
    if [[ -z "$brew_bin" ]]; then
        if [[ "$(uname -m)" == arm64 && -x /opt/homebrew/bin/brew ]]; then
            brew_bin=/opt/homebrew/bin/brew
        elif [[ -x /usr/local/bin/brew ]]; then
            brew_bin=/usr/local/bin/brew
        fi
    fi
    [[ -x "$brew_bin" ]] || die "Homebrew is installed but brew is not available on PATH"

    eval "$("$brew_bin" shellenv)"
    local shellenv_line="eval \"\$(${brew_bin} shellenv)\""
    if ! grep -Fqx "$shellenv_line" "$HOME/.zprofile" 2>/dev/null; then
        print -r -- "$shellenv_line" >> "$HOME/.zprofile"
    fi
}

preflight_homebrew() {
    local brew_prefix brew_cache path
    brew_prefix="$(brew --prefix)"
    brew_cache="$(brew --cache)"

    for path in "$brew_prefix" "$brew_prefix/Cellar" "$brew_prefix/Caskroom" "$brew_cache"; do
        if [[ -e "$path" && ! -w "$path" ]]; then
            die "Homebrew path is not writable: $path. Fix ownership/permissions, then rerun."
        fi
    done

    echo "Homebrew prefix: $brew_prefix"
    echo "Homebrew cache: $brew_cache"
}

show_menu() {
    if [[ "$MENU_ENABLED" != true || "$NON_INTERACTIVE" == true || ! -t 0 || ! -t 1 ]]; then
        echo "Non-interactive mode: using selected/default installation options"
        return
    fi

    if ! command -v gum >/dev/null 2>&1; then
        echo "gum is unavailable; using selected/default installation options"
        return
    fi

    gum style \
        --border normal \
        --border-foreground 212 \
        --margin "1 2" \
        --padding "1 2" \
        "Welcome back, let's set up your workspace! 🚀"
    echo "Please select which components you'd like to install:"

    INSTALL_GENERAL=$(gum choose --selected=true "Install" "Skip" --header="📦 General Tools")
    INSTALL_GENERAL=$([[ "$INSTALL_GENERAL" == Install ]] && echo true || echo false)
    INSTALL_DEV=$(gum choose --selected=true "Install" "Skip" --header="💻 Development Tools")
    INSTALL_DEV=$([[ "$INSTALL_DEV" == Install ]] && echo true || echo false)
    INSTALL_COMM=$(gum choose --selected=true "Install" "Skip" --header="📞 Communication Tools")
    INSTALL_COMM=$([[ "$INSTALL_COMM" == Install ]] && echo true || echo false)
    INSTALL_SHELL=$(gum choose --selected=true "Install" "Skip" --header="🐚 Shell Configuration")
    INSTALL_SHELL=$([[ "$INSTALL_SHELL" == Install ]] && echo true || echo false)

    echo ""
    echo "=== Installation Summary ==="
    echo "General Tools: $([[ "$INSTALL_GENERAL" == true ]] && echo ✅ || echo ❌)"
    echo "Development Tools: $([[ "$INSTALL_DEV" == true ]] && echo ✅ || echo ❌)"
    echo "Communication Tools: $([[ "$INSTALL_COMM" == true ]] && echo ✅ || echo ❌)"
    echo "Shell Configuration: $([[ "$INSTALL_SHELL" == true ]] && echo ✅ || echo ❌)"
    gum confirm "Do you want to proceed with the installation?" || exit 0
}

download() {
    local destination="$1"
    local url="$2"
    curl --fail --show-error --location --retry 3 --output "$destination" "$url"
}

install_dotnet() {
    if command -v dotnet >/dev/null 2>&1; then
        echo ".NET SDK is already installed: $(dotnet --version)"
        return 0
    fi

    local releases_json latest_lts release_json pkg_url arch
    arch="$(uname -m)"
    [[ "$arch" == arm64 ]] || arch=x64
    releases_json="$(curl --fail --silent --show-error --location https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json)"
    latest_lts="$(echo "$releases_json" | jq -r '[ ."releases-index"[] | select(."release-type" == "lts" and ."support-phase" == "active") | ."channel-version" ] | sort_by(split(".") | map(tonumber)) | last')"
    [[ -n "$latest_lts" ]] || die "Could not determine the latest active .NET LTS version"

    echo "Found .NET SDK LTS version: $latest_lts"
    release_json="$(curl --fail --silent --show-error --location "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/$latest_lts/releases.json")"
    pkg_url="$(echo "$release_json" | jq -r --arg arch "$arch" '.releases[0].sdk.files[] | select(.name | endswith("osx-" + $arch + ".pkg")) | .url' | head -n1)"
    [[ -n "$pkg_url" && "$pkg_url" != null ]] || die "Could not determine the .NET SDK download URL"

    download "$TMP_DIR/dotnet-sdk.pkg" "$pkg_url"
    sudo installer -pkg "$TMP_DIR/dotnet-sdk.pkg" -target /
}

install_aws_cli() {
    if command -v aws >/dev/null 2>&1; then
        echo "AWS CLI is already installed: $(aws --version 2>&1)"
        return 0
    fi

    download "$TMP_DIR/AWSCLIV2.pkg" "https://awscli.amazonaws.com/AWSCLIV2.pkg"
    sudo installer -pkg "$TMP_DIR/AWSCLIV2.pkg" -target /
}

configure_shell() {
    local brew_prefix zsh_path zsh_custom dotnet_root
    brew_prefix="$(brew --prefix)"
    zsh_path="$(command -v zsh)"
    [[ -x "$zsh_path" ]] || die "zsh is not available"

    dotnet_root="$brew_prefix/opt/dotnet/libexec"
    for candidate in /usr/local/share/dotnet "$brew_prefix/opt/dotnet/libexec"; do
        if [[ -x "$candidate/dotnet" ]]; then
            dotnet_root="$candidate"
            break
        fi
    done

    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
    fi

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    mkdir -p "$zsh_custom/themes" "$zsh_custom/plugins"
    [[ -d "$zsh_custom/themes/powerlevel10k" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
    [[ -d "$zsh_custom/plugins/zsh-autosuggestions" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    [[ -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"

    if [[ -f "$HOME/.zshrc" ]]; then
        local backup_path="$HOME/.zshrc.backup-$(date +%Y%m%d_%H%M%S)"
        cp -p "$HOME/.zshrc" "$backup_path"
        echo "Backed up existing .zshrc to $backup_path"
    fi

    cat > "$HOME/.zshrc" <<EOF
# Enable Powerlevel10k instant prompt
if [[ -r "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh" ]]; then
  source "\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh"
fi

export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git docker dotnet node npm zsh-autosuggestions zsh-syntax-highlighting)
source "\$ZSH/oh-my-zsh.sh"

export PATH="$dotnet_root:\$PATH"
export DOTNET_ROOT="$dotnet_root"
export NVM_DIR="\$HOME/.nvm"
[[ -s "$brew_prefix/opt/nvm/nvm.sh" ]] && source "$brew_prefix/opt/nvm/nvm.sh"
[[ -s "$brew_prefix/opt/nvm/etc/bash_completion.d/nvm" ]] && source "$brew_prefix/opt/nvm/etc/bash_completion.d/nvm"
[[ ! -f \$HOME/.p10k.zsh ]] || source \$HOME/.p10k.zsh
EOF

    if [[ -n "${GIT_USER_NAME:-}" ]]; then
        git config --global user.name "$GIT_USER_NAME"
    fi
    if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
        git config --global user.email "$GIT_USER_EMAIL"
    fi
    git config --global push.default current
    if command -v code >/dev/null 2>&1; then
        git config --global core.editor "code --wait"
    fi
    git config --global init.defaultBranch main
    if command -v git-lfs >/dev/null 2>&1; then
        git lfs install --skip-repo
    fi
}

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mac-setup.XXXXXX")"
trap '[[ -n "$TMP_DIR" && -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"' EXIT

if should_run 1; then
    ensure_homebrew
    preflight_homebrew
    save_progress 1
fi

if should_run 2; then
    install_if_not_exists gum
    show_menu
    save_progress 2
fi

if should_run 3; then
    echo "=== Updating Homebrew and installing prerequisites ==="
    if ! brew update; then
        die "Homebrew update failed. Check network access, DNS, permissions, and Homebrew taps."
    fi
    for tool in curl git jq; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            install_if_not_exists "$tool"
        fi
    done
    save_progress 3
fi

if should_run 4 && [[ "$INSTALL_GENERAL" == true ]]; then
    echo "=== Installing General Tools ==="
    install_if_not_exists microsoft-edge cask
    install_if_not_exists google-chrome cask
    install_if_not_exists spotify cask
    install_if_not_exists notion cask
    install_if_not_exists bitwarden cask
    install_if_not_exists btop
    install_if_not_exists ghostty cask
    install_if_not_exists iterm2 cask
    install_if_not_exists raycast cask
    install_if_not_exists microsoft-outlook cask
    install_if_not_exists fastfetch
    install_if_not_exists rectangle cask
    install_if_not_exists thaw cask
    install_if_not_exists obsidian cask
    install_if_not_exists windows-app cask
    install_if_not_exists lazydocker
    install_if_not_exists shottr cask
    save_progress 4
elif should_run 4; then
    save_progress 4
fi

if should_run 5 && [[ "$INSTALL_COMM" == true ]]; then
    echo "=== Installing Communication Tools ==="
    install_if_not_exists discord cask
    install_if_not_exists slack cask
    install_if_not_exists microsoft-teams cask
    save_progress 5
elif should_run 5; then
    save_progress 5
fi

if should_run 6 && [[ "$INSTALL_DEV" == true ]]; then
    echo "=== Installing Development Tools ==="
    install_dotnet
    install_if_not_exists git-lfs
    install_if_not_exists nvm
    install_if_not_exists yarn
    install_if_not_exists jetbrains-toolbox cask
    install_if_not_exists visual-studio-code cask
    install_if_not_exists orbstack cask
    install_if_not_exists neovim
    install_if_not_exists postman cask
    install_if_not_exists zed cask
    install_if_not_exists opencode
    install_aws_cli
    install_if_not_exists azure-cli
    save_progress 6
elif should_run 6; then
    save_progress 6
fi

if should_run 7 && [[ "$INSTALL_SHELL" == true ]]; then
    echo "=== Configuring Shell Environment ==="
    configure_shell
    save_progress 7
elif should_run 7; then
    save_progress 7
fi

if should_run 8; then
    echo "=== Cleaning up ==="
    brew cleanup
    rm -f "$STATE_FILE"
fi

cat <<EOF

Setup completed successfully.
Log file: $LOG_FILE

Next steps:
  1. Run 'p10k configure' if you want to customize the prompt.
  2. Set GIT_USER_NAME and GIT_USER_EMAIL if Git identity was not configured.
  3. Log in to installed applications.
EOF
