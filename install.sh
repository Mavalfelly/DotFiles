#!/usr/bin/env bash
# ============================================================================
# DotFiles Installation Script
# ============================================================================
# Author: Mavalfelly
# Repository: DotFiles
# Last Modified: 2025-08-09
#
# This script will automatically:
# 1. Install ZSH and set it as default shell
# 2. Install Neovim and development tools
# 3. Install Node.js, Python, Java and their package managers
# 4. Configure all environment variables and paths
# 5. Set up the development environment
# ============================================================================

set -e  # Exit on error

# Detect Debian-based Distribution
if [ ! -f /etc/os-release ]; then
    echo "This script only supports Debian-based Linux systems"
    exit 1
fi

. /etc/os-release
OS=$ID_LIKE

if [[ "$OS" != *"debian"* ]]; then
    echo "This script only supports Debian-based systems"
    exit 1
fi

# Install basic dependencies
install_dependencies() {
    echo "▶ Installing system packages..."
    sudo apt update
    sudo apt install -y zsh git curl wget fd-find ripgrep fzf htop tree
    sudo apt install -y build-essential
    
    # Install Python build dependencies
    echo "▶ Installing Python build dependencies..."
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev python3-dev
}

# Install Neovim from source and set up LazyVim
install_neovim() {
    echo "▶ Removing existing Neovim installations..."
    # Remove APT package if installed
    sudo apt-get remove -y neovim neovim-runtime
    sudo apt-get purge -y neovim neovim-runtime
    sudo apt-get autoremove -y
    
    # Clean up any previous source builds
    rm -rf "/tmp/neovim"
    
    # Remove any existing source build
    sudo rm -f /usr/local/bin/nvim
    sudo rm -rf /usr/local/share/nvim/
    
    echo "▶ Installing Neovim build dependencies..."
    sudo apt-get install -y ninja-build gettext cmake unzip curl git build-essential

    echo "▶ Cloning Neovim repository..."
    git clone https://github.com/neovim/neovim /tmp/neovim
    cd /tmp/neovim

    echo "▶ Building Neovim from source..."
    git checkout master
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    cd -
    rm -rf /tmp/neovim

    # Verify installation
    nvim --version

    echo "▶ Setting up LazyVim..."
    # Clean existing Neovim configs
    rm -rf "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"

    # Create required directory
    mkdir -p "$HOME/.config/nvim"

    # Clone LazyVim starter
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"  # Remove git repo to allow for own version control

    # Copy our custom Neovim config files
    cp -r "$HOME/.dotfiles/.config/nvim/"* "$HOME/.config/nvim/"

    echo "LazyVim setup complete. First run will install plugins automatically."
    
    # Print Neovim version for verification
    echo "Installed Neovim version:"
    nvim --version | head -n 1
}

# Set ZSH as default shell
setup_zsh() {
    echo "▶ Checking current shell..."
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "▶ Setting ZSH as default shell..."
        chsh -s $(which zsh)
    else
        echo "▶ ZSH is already the default shell"
    fi
}

# Install Node.js via nvm
install_node() {
    echo "▶ Cleaning up Node.js-related directories..."
    rm -rf "$HOME/.nvm"                 # Remove nvm (not needed anymore)
    rm -rf "$HOME/.npm"
    rm -rf "$HOME/.npm-packages"
    rm -rf "$HOME/.npm-global"          # Will be recreated by new installation
    rm -rf "$HOME/.node-gyp"
    rm -rf "$HOME/.yarn"
    rm -rf "$HOME/.pnpm-store"
    
    # Remove NodeSource repository if it exists
    sudo rm -f /etc/apt/sources.list.d/nodesource.list
    sudo rm -f /usr/share/keyrings/nodesource.gpg
    
    # Also unset environment variables
    unset NPM_CONFIG_PREFIX
    unset NPM_CONFIG_GLOBALCONFIG
    unset NPM_CONFIG_INIT_MODULE
    
    echo "▶ Installing Node.js from NodeSource repository..."
    
    # Add NodeSource repository for latest LTS
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    
    # Install Node.js and npm
    sudo apt-get install -y nodejs
    
    echo "▶ Verifying Node.js installation..."
    if ! command -v node >/dev/null 2>&1; then
        echo "❌ Node.js installation failed."
        return 1
    fi
    
    if ! command -v npm >/dev/null 2>&1; then
        echo "❌ npm installation failed."
        return 1
    fi
    
    echo "▶ Configuring npm for global packages..."
    
    # Create npm global directory in user home
    mkdir -p "$HOME/.npm-global"
    
    # Configure npm to use the global directory
    npm config set prefix "$HOME/.npm-global"
    
    # Add npm global bin to PATH for this session
    export PATH="$HOME/.npm-global/bin:$PATH"
    
    # Add to shell profiles for persistence
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$HOME/.bashrc"
    
    echo "▶ Installing global npm packages..."
    npm install -g yarn pnpm typescript ts-node
    
    echo "▶ Verifying installations..."
    echo "Node version: $(node --version)"
    echo "NPM version: $(npm --version)"
    
    # Check yarn installation
    if command -v yarn >/dev/null 2>&1; then
        echo "Yarn version: $(yarn --version)"
    else
        echo "Yarn: Not installed or not in PATH"
    fi
    
    # Check pnpm installation
    if command -v pnpm >/dev/null 2>&1; then
        echo "PNPM version: $(pnpm --version)"
    else
        echo "PNPM: Not installed or not in PATH"
    fi
    
    # Check TypeScript installation
    if command -v tsc >/dev/null 2>&1; then
        echo "TypeScript version: $(tsc --version)"
    else
        echo "TypeScript: Not installed or not in PATH"
    fi
    
    echo "✅ Node.js installation completed successfully!"
}

# Install Python via pyenv
install_python() {
    echo "▶ Cleaning up previous Python installations..."
    rm -rf "$HOME/.pyenv"
    rm -rf "$HOME/.poetry"
    rm -rf "$HOME/.local/share/pypoetry"
    rm -rf "$HOME/.cache/pypoetry"
    
    echo "▶ Installing Python Version Manager (pyenv)..."
    curl https://pyenv.run | bash
    
    # Set up pyenv in the shell
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)"
    eval "$(pyenv virtualenv-init -)"
    
    # Add pyenv to shell rc files
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
    
    # Also add to profile for login shells
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
    echo 'eval "$(pyenv init -)"' >> ~/.profile
    
    # Reload shell environment
    source ~/.bashrc
    
    echo "▶ Installing latest stable Python version..."
    pyenv install $(pyenv install -l | grep -v '[a-zA-Z]' | tail -1)
    pyenv global $(pyenv install -l | grep -v '[a-zA-Z]' | tail -1)
    
    # Add local bin to PATH for Python packages
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
}

# Install Java via SDKMAN
install_java() {
    echo "▶ Cleaning up previous Java installations..."
    rm -rf "$HOME/.sdkman"
    
    echo "▶ Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    
    echo "▶ Installing latest Java 21..."
    sdk install java $(sdk list java | grep -o "21\.[0-9.]*-amzn" | head -1)
}

# Setup dotfiles
setup_dotfiles() {
    echo "▶ Creating configuration directories..."
    # Create necessary directories
    mkdir -p "$HOME/.config/nvim"
    mkdir -p "$HOME/.local/share/zinit"
    
    # Backup existing configs
    [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    
    # Copy this file as .zshrc
    cp "$0" "$HOME/.zshrc"
    
    # Remove the installation script part (everything before # ENVIRONMENT VARIABLES)
    sed -i '1,/# ENVIRONMENT VARIABLES/d' "$HOME/.zshrc"
}

# Cleanup old shell configurations
cleanup_old_configs() {
    echo "▶ Removing old shell configuration files..."
    
    # Remove old shell config files
    rm -f ~/.bashrc ~/.bash_profile ~/.bash_login ~/.profile ~/.bash_logout
    rm -f ~/.zshrc ~/.zshenv ~/.zprofile ~/.zlogin ~/.zlogout
    rm -f ~/.inputrc ~/.bash_history ~/.zsh_history
    
    # Remove old package managers and their configs
    rm -rf ~/.oh-my-zsh ~/.antigen ~/.zinit ~/.zplug
    rm -rf ~/.sdkman ~/.nvm ~/.pyenv
    
    # Remove old shell plugins
    rm -rf ~/.zsh ~/.bash-completion
    
    # Clean apt packages (for Debian/Ubuntu)
    echo "Removing old shell-related packages..."
    sudo apt remove -y fish tcsh ksh bash-completion zsh-syntax-highlighting zsh-autosuggestions 2>/dev/null || true
    sudo apt autoremove -y
}

# Clean installation directories
cleanup_install_dirs() {
    echo "▶ Cleaning up previous installations..."
    
    echo "▶ Removing system-level packages..."
    # Remove system Python installations (except system python3)
    sudo apt-get remove -y python2* python3-pip python3-dev python3-venv
    # Remove Node.js and npm
    sudo apt-get remove -y nodejs npm
    # Remove Java
    sudo apt-get remove -y default-jdk default-jre openjdk* oracle-java*
    sudo apt-get autoremove -y
    
    echo "▶ Cleaning up Python-related directories..."
    rm -rf "$HOME/.pyenv"
    rm -rf "$HOME/.poetry"
    rm -rf "$HOME/.local/share/pypoetry"
    rm -rf "$HOME/.cache/pypoetry"
    rm -rf "$HOME/.local/lib/python*"
    rm -rf "$HOME/.local/share/virtualenv"
    rm -rf "$HOME/.cache/pip"
    
    echo "▶ Cleaning up Node.js-related directories..."
    rm -rf "$HOME/.nvm"
    rm -rf "$HOME/.npm"
    rm -rf "$HOME/.npm-packages"
    rm -rf "$HOME/.npm-global"          # Fixed: Added this line
    rm -rf "$HOME/.node-gyp"
    rm -rf "$HOME/.yarn"
    rm -rf "$HOME/.pnpm-store"
    
    # Also unset environment variables
    unset NPM_CONFIG_PREFIX
    unset NPM_CONFIG_GLOBALCONFIG
    unset NPM_CONFIG_INIT_MODULE
    
    echo "▶ Cleaning up Java-related directories..."
    rm -rf "$HOME/.sdkman"
    rm -rf "$HOME/.gradle"
    rm -rf "$HOME/.m2"
    sudo rm -rf /usr/lib/jvm/*
    
    echo "▶ Cleaning up temporary directories..."
    rm -rf "/tmp/neovim"
    rm -rf "/tmp/poetry-installer-*"
    rm -rf "/tmp/node-*"
    rm -rf "/tmp/npm-*"
    rm -rf "/tmp/pyenv-*"
    
    echo "▶ Removing any leftover binaries..."
    sudo rm -f /usr/local/bin/{node,npm,python*,pip*,java,javac}
}

# Print stage header
print_stage() {
    local stage="$1"
    echo
    echo "================================================================"
    echo "  ${stage}"
    echo "================================================================"
}

# Track installation status
declare -A install_status

# Main installation
main() {
    local start_time=$(date +%s)
    
    print_stage "CLEANING UP INSTALLATIONS"
    cleanup_install_dirs
    
    print_stage "CLEANING OLD CONFIGURATIONS"
    if cleanup_old_configs; then
        install_status["cleanup"]="✓ Success"
    else
        install_status["cleanup"]="✗ Failed"
    fi
    
    print_stage "INSTALLING DEPENDENCIES"
    if install_dependencies; then
        install_status["dependencies"]="✓ Success"
    else
        install_status["dependencies"]="✗ Failed"
    fi
    
    print_stage "INSTALLING NODE.JS"
    if install_node; then
        install_status["node"]="✓ Success"
    else
        install_status["node"]="✗ Failed"
    fi

    print_stage "INSTALLING NEOVIM"
    if install_neovim; then
        install_status["neovim"]="✓ Success"
    else
        install_status["neovim"]="✗ Failed"
    fi
    
    print_stage "SETTING UP ZSH"
    if setup_zsh; then
        install_status["zsh"]="✓ Success"
    else
        install_status["zsh"]="✗ Failed"
    fi
    
    print_stage "INSTALLING PYTHON"
    if install_python; then
        install_status["python"]="✓ Success"
    else
        install_status["python"]="✗ Failed"
    fi
    
    print_stage "INSTALLING JAVA"
    if install_java; then
        install_status["java"]="✓ Success"
    else
        install_status["java"]="✗ Failed"
    fi
    
    print_stage "SETTING UP DOTFILES"
    if setup_dotfiles; then
        install_status["dotfiles"]="✓ Success"
    else
        install_status["dotfiles"]="✗ Failed"
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Print installation report
    echo
    echo "================================================================"
    echo "                    INSTALLATION REPORT"
    echo "================================================================"
    echo "Cleanup:              ${install_status["cleanup"]}"
    echo "Dependencies:         ${install_status["dependencies"]}"
    echo "Neovim:              ${install_status["neovim"]}"
    echo "Zsh:                 ${install_status["zsh"]}"
    echo "Node.js:             ${install_status["node"]}"
    echo "Python:              ${install_status["python"]}"
    echo "Java:                ${install_status["java"]}"
    echo "Dotfiles:            ${install_status["dotfiles"]}"
    echo "----------------------------------------------------------------"
    echo "Total Duration:      ${duration} seconds"
    echo "----------------------------------------------------------------"
    echo
    echo "Installation complete! Please restart your shell."
    echo "================================================================"
}

# Run main if script is executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi

# ============================================================================
# INSTALLATION SUMMARY
# ============================================================================
#
# Quick setup for new machine:
#
# 1. Install zsh and make it default:
#    sudo apt install zsh && chsh -s $(which zsh)
#
# 2. Install essential tools:
#    sudo apt install git curl wget fd-find ripgrep fzf htop tree neovim
#
# 3. Install development environments:
#    # Node.js/JavaScript
#    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
#    
#    # Python
#    curl https://pyenv.run | bash
#    curl -sSL https://install.python-poetry.org | python3 -
#    
#    # Java
#    curl -s "https://get.sdkman.io" | bash
#
# 4. Clone your dotfiles and setup:
#    git clone [your-repo] ~/dotfiles
#    ln -sf ~/dotfiles/.zshrc ~/.zshrc
#    source ~/.zshrc
#
# ============================================================================