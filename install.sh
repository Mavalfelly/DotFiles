#!/usr/bin/env bash
# ============================================================================
# DotFiles Installation Script
# ============================================================================
# Author: Matt Felly
# Repository: DotFiles
# Last Modified: 2025-08-27
#
# This script assumes you've already cloned the dotfiles repo to ~/.dotfiles:
# git clone https://github.com/Mavalfelly/DotFiles.git ~/.dotfiles
#
# This script will automatically:
# 1. Clean existing configurations
# 2. Install ZSH and set it as default shell
# 3. Install Neovim and development tools
# 4. Install Node.js, Python, Java and their package managers
# 5. Configure all environment variables and paths
# 6. Set up the development environment from ~/.dotfiles
# ============================================================================

set -e

TOTAL_STAGES=12
CURRENT_STAGE=0

print_progress() {
    local percentage=$(( (CURRENT_STAGE * 100) / TOTAL_STAGES ))
    local filled_length=$(( (percentage * 40) / 100 ))
    local empty_length=$(( 40 - filled_length ))
    
    local filled_bar=$(printf "%${filled_length}s" | tr ' ' '█')
    local empty_bar=$(printf "%${empty_length}s" | tr ' ' '░')
    
    echo -ne "\rProgress: [${filled_bar}${empty_bar}] ${percentage}% "
}

run_test() {
    local description="$1"
    local command_to_run="$2"
    
    echo "  🧪 Testing: $description"
    if eval "$command_to_run"; then
        echo "    ✅ Passed"
    else
        echo "    ❌ Failed: $description"
    fi
}

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "❌ DotFiles repository not found at ~/.dotfiles"
    echo "Please run: git clone https://github.com/Mavalfelly/DotFiles.git ~/.dotfiles"
    exit 1
fi

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

clean_shell_configs() {
    echo "▶ Cleaning existing shell configuration files..."
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$HOME/.config_backup_$timestamp"
    
    if [[ -f "$HOME/.zshrc" || -f "$HOME/.bashrc" || -f "$HOME/.profile" ]]; then
        echo "  Creating backup at $backup_dir"
        mkdir -p "$backup_dir"

        [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$backup_dir/.zshrc"
        [[ -f "$HOME/.bashrc" ]] && cp "$HOME/.bashrc" "$backup_dir/.bashrc"
        [[ -f "$HOME/.profile" ]] && cp "$HOME/.profile" "$backup_dir/.profile"
        [[ -f "$HOME/.bash_profile" ]] && cp "$HOME/.bash_profile" "$backup_dir/.bash_profile"
        [[ -f "$HOME/.zshenv" ]] && cp "$HOME/.zshenv" "$backup_dir/.zshenv"
    fi

    rm -f "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile" "$HOME/.bash_logout"
    rm -f "$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zlogin" "$HOME/.zlogout"
    rm -f "$HOME/.inputrc"

    rm -rf "$HOME/.oh-my-zsh"
    rm -rf "$HOME/.antigen"
    rm -rf "$HOME/.zinit"
    rm -rf "$HOME/.zplug"
    rm -rf "$HOME/.zsh"
    
    echo "  Shell configs cleaned"
}

clean_neovim() {
    echo "▶ Cleaning Neovim installations and configurations..."
    
    sudo apt-get remove -y neovim neovim-runtime 2>/dev/null || true
    sudo apt-get purge -y neovim neovim-runtime 2>/dev/null || true
    sudo apt-get autoremove -y
    sudo rm -f /usr/local/bin/nvim
    sudo rm -rf /usr/local/share/nvim/
    sudo rm -rf /usr/local/lib/nvim/
    
    rm -rf "$HOME/.config/nvim"
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.cache/nvim"
    rm -rf "/tmp/neovim"
    
    echo "  Neovim cleanup completed"
}

clean_nodejs() {
    echo "▶ Cleaning Node.js installations and configurations..."
    
    sudo apt-get remove -y nodejs npm 2>/dev/null || true
    sudo apt-get autoremove -y
    sudo rm -f /etc/apt/sources.list.d/nodesource.list
    sudo rm -f /usr/share/keyrings/nodesource.gpg
    sudo rm -f /usr/local/bin/node
    sudo rm -f /usr/local/bin/npm
    sudo rm -f /usr/local/bin/npx
    sudo rm -f /usr/local/bin/yarn
    sudo rm -f /usr/local/bin/pnpm
    sudo rm -f /usr/local/bin/tsc
    sudo rm -f /usr/local/bin/ts-node
    
    rm -rf "$HOME/.nvm"
    rm -rf "$HOME/.npm"
    rm -rf "$HOME/.npm-packages"
    rm -rf "$HOME/.npm-global"
    rm -rf "$HOME/.node-gyp"
    rm -rf "$HOME/.yarn"
    rm -rf "$HOME/.pnpm-store"
    rm -rf "$HOME/.cache/npm"
    rm -rf "$HOME/.cache/yarn"
    rm -rf "$HOME/.cache/pnpm"
    
    unset NPM_CONFIG_PREFIX
    unset NPM_CONFIG_GLOBALCONFIG
    unset NPM_CONFIG_INIT_MODULE
    unset NVM_DIR
    
    echo "  Node.js cleanup completed"
}

clean_python() {
    echo "▶ Cleaning Python installations and configurations..."
    
    sudo apt-get remove -y python2* python3-pip python3-dev python3-venv 2>/dev/null || true
    sudo apt-get autoremove -y
    
    rm -rf "$HOME/.pyenv"
    rm -rf "$HOME/.poetry"
    rm -rf "$HOME/.local/share/pypoetry"
    rm -rf "$HOME/.cache/pypoetry"
    rm -rf "$HOME/.local/lib/python*"
    rm -rf "$HOME/.local/share/virtualenv"
    rm -rf "$HOME/.cache/pip"
    rm -rf "$HOME/.cache/pypoetry"
    
    sudo rm -f /usr/local/bin/python*
    sudo rm -f /usr/local/bin/pip*
    sudo rm -f /usr/local/bin/poetry
    
    unset PYENV_ROOT
    unset PYENV_VERSION
    unset POETRY_HOME
    
    echo "  Python cleanup completed"
}

clean_java() {
    echo "▶ Cleaning Java installations and configurations..."
    
    sudo apt-get remove -y default-jdk default-jre openjdk* oracle-java* 2>/dev/null || true
    sudo apt-get autoremove -y

    rm -rf "$HOME/.sdkman"
    rm -rf "$HOME/.gradle"
    rm -rf "$HOME/.m2"
    rm -rf "$HOME/.cache/gradle"
    sudo rm -rf /usr/lib/jvm/*
    sudo rm -f /usr/local/bin/java
    sudo rm -f /usr/local/bin/javac
    sudo rm -f /usr/local/bin/jar

    unset JAVA_HOME
    unset SDKMAN_DIR
    
    echo "  Java cleanup completed"
}

install_dependencies() {
    echo "▶ Installing system packages..."
    sudo apt update
    sudo apt install -y zsh git curl wget fd-find ripgrep fzf htop tree
    sudo apt install -y build-essential

    echo "▶ Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    echo "▶ Installing Python build dependencies..."
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev python3-dev

    echo "▶ Verifying dependencies..."
    run_test "ZSH is installed" "command -v zsh"
    run_test "Git is installed" "command -v git"
    run_test "curl is installed" "command -v curl"
    run_test "Starship is installed" "command -v starship"
}

install_neovim() {
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

    echo "▶ Verifying Neovim installation..."
    run_test "Neovim is installed" "command -v nvim"
    run_test "Neovim version check" "nvim --version"

    echo "▶ Setting up LazyVim with custom config..."
    mkdir -p "$HOME/.config/nvim"

    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"

    if [ -d "$HOME/.dotfiles/.config/nvim" ]; then
        echo "  Copying custom Neovim config from ~/.dotfiles"
        cp -r "$HOME/.dotfiles/.config/nvim/"* "$HOME/.config/nvim/"
    else
        echo "  No custom Neovim config found in ~/.dotfiles/.config/nvim"
    fi

    echo "LazyVim setup complete. First run will install plugins automatically."
}

setup_zsh() {
    echo "▶ Checking current shell..."
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "▶ Setting ZSH as default shell..."
        chsh -s $(which zsh)
    else
        echo "▶ ZSH is already the default shell"
    fi
    run_test "Default shell is ZSH" "[ \"$SHELL\" = \"$(which zsh)\" ]"
}

install_node() {
    echo "▶ Installing Node.js from NodeSource repository..."
    
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    
    sudo apt-get install -y nodejs
    
    echo "▶ Configuring npm for global packages..."
    
    mkdir -p "$HOME/.npm-global"
    
    npm config set prefix "$HOME/.npm-global"
    
    export PATH="$HOME/.npm-global/bin:$PATH"
    
    echo "▶ Installing global npm packages..."
    npm install -g yarn pnpm typescript ts-node
    
    echo "▶ Verifying Node.js installations..."
    run_test "Node.js is installed" "command -v node"
    run_test "npm is installed" "command -v npm"
    run_test "Yarn is installed" "command -v yarn"
    run_test "pnpm is installed" "command -v pnpm"
    run_test "TypeScript is installed" "command -v tsc"
    
    echo "✅ Node.js installation completed successfully!"
}

install_python() {
	echo "▶ Installing Python Version Manager (pyenv)..."
	curl https://pyenv.run | bash

	export PYENV_ROOT="$HOME/.pyenv"
	[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init - bash)"
	eval "$(pyenv virtualenv-init -)"

	run_test "pyenv is installed" "command -v pyenv"

	echo "▶ Installing latest stable Python version..."
	local latest_python=$(pyenv install -l | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
	pyenv install "$latest_python"
	pyenv global "$latest_python"

	run_test "Python is installed" "command -v python"
	run_test "Correct Python version is active" "pyenv version-name | grep -q $latest_python"

	echo "▶ Installing Poetry..."
	rm -f "$HOME/.local/bin/poetry"
	curl -sSL https://install.python-poetry.org | python3 -
	export PATH="$HOME/.local/bin:$PATH"

	run_test "Poetry is installed" "command -v poetry"

	echo "✅ Python installation completed successfully!"
}

install_java() {
    echo "▶ Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    
    run_test "SDKMAN is installed" "command -v sdk"

    echo "▶ Installing latest Java 21 (Amazon Corretto)..."
    local latest_java=$(sdk list java | grep -o '21\.[0-9\.]*-amzn' | head -1)
    sdk install java "$latest_java"
    
    run_test "Java is installed" "command -v java"
    
    local java_version_number=$(echo "$latest_java" | cut -d'-' -f1)
    run_test "Correct Java version is active" "java -version 2>&1 | grep -q $java_version_number"

    echo "✅ Java installation completed successfully!"
}

setup_dotfiles() {
    echo "▶ Setting up dotfiles from ~/.dotfiles..."
    
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/share/zinit"
    
    if [ -f "$HOME/.dotfiles/.zshrc" ]; then
        echo "  Copying .zshrc from ~/.dotfiles"
        cp "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
        run_test ".zshrc was copied" "[ -f \"$HOME/.zshrc\" ]"
    else
        echo "  ⚠️  .zshrc not found in ~/.dotfiles"
    fi

    if [ -d "$HOME/.dotfiles/.config/starship.toml" ]; then
        echo "  Copying starship.toml from ~/.dotfiles"
        cp "$HOME/.dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"
        run_test "starship.toml was copied" "[ -f \"$HOME/.config/starship.toml\" ]"
    fi

    if [ -d "$HOME/.dotfiles/.config/nvim" ] && [ ! -d "$HOME/.config/nvim" ]; then
        echo "  Copying Neovim config from ~/.dotfiles"
        cp -r "$HOME/.dotfiles/.config/nvim" "$HOME/.config/"
    elif [ -d "$HOME/.dotfiles/.config/nvim" ]; then
        echo "  Updating Neovim config from ~/.dotfiles"
        rm -rf "$HOME/.config/nvim"
        cp -r "$HOME/.dotfiles/.config/nvim" "$HOME/.config/"
    fi
    run_test "Neovim config directory exists" "[ -d \"$HOME/.config/nvim\" ]"

    if [ -d "$HOME/.dotfiles/.config" ]; then
        echo "  Copying additional configs from ~/.dotfiles/.config"
        for item in "$HOME/.dotfiles/.config"/*; do
            if [ -d "$item" ] && [ "$(basename "$item")" != "nvim" ]; then
                cp -r "$item" "$HOME/.config/"
            elif [ -f "$item" ]; then
                cp "$item" "$HOME/.config/"
            fi
        done
    fi
    
    echo "✅ Dotfiles setup completed successfully!"
}


print_stage() {
    local stage="$1"
    CURRENT_STAGE=$((CURRENT_STAGE + 1))
    local percentage=$(( (CURRENT_STAGE * 100) / TOTAL_STAGES ))
    
    local bar_length=25
    local filled_length=$(( (percentage * bar_length) / 100 ))
    local empty_length=$(( bar_length - filled_length ))
    local filled_bar=$(printf "%${filled_length}s" | tr ' ' '█')
    local empty_bar=$(printf "%${empty_length}s" | tr ' ' '░')

    echo
    echo "================================================================"
    echo "  Progress: [${filled_bar}${empty_bar}] ${percentage}%"
    echo "  Stage ${CURRENT_STAGE}/${TOTAL_STAGES}: ${stage}"
    echo "================================================================"
}

declare -A install_status

main() {
    local start_time=$(date +%s)
    
    echo "================================================================"
    echo "  DOTFILES INSTALLATION STARTING"
    echo "  Repository: ~/.dotfiles"
    echo "================================================================"
    
    print_stage "CLEANING SHELL CONFIGURATIONS"
    if clean_shell_configs; then
        install_status["shell_cleanup"]="✓ Success"
    else
        install_status["shell_cleanup"]="✗ Failed"
    fi
    
    print_stage "CLEANING NEOVIM"
    if clean_neovim; then
        install_status["neovim_cleanup"]="✓ Success"
    else
        install_status["neovim_cleanup"]="✗ Failed"
    fi
    
    print_stage "CLEANING NODE.JS"
    if clean_nodejs; then
        install_status["nodejs_cleanup"]="✓ Success"
    else
        install_status["nodejs_cleanup"]="✗ Failed"
    fi
    
    print_stage "CLEANING PYTHON"
    if clean_python; then
        install_status["python_cleanup"]="✓ Success"
    else
        install_status["python_cleanup"]="✗ Failed"
    fi
    
    print_stage "CLEANING JAVA"
    if clean_java; then
        install_status["java_cleanup"]="✓ Success"
    else
        install_status["java_cleanup"]="✗ Failed"
    fi
    
    print_stage "INSTALLING DEPENDENCIES"
    if install_dependencies; then
        install_status["dependencies"]="✓ Success"
    else
        install_status["dependencies"]="✗ Failed"
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
    
    print_stage "INSTALLING NODE.JS"
    if install_node; then
        install_status["node"]="✓ Success"
    else
        install_status["node"]="✗ Failed"
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
    
    echo
    echo "================================================================"
    echo "                    INSTALLATION REPORT"
    echo "================================================================"
    echo "Shell Cleanup:       ${install_status["shell_cleanup"]}"
    echo "Neovim Cleanup:      ${install_status["neovim_cleanup"]}"
    echo "Node.js Cleanup:     ${install_status["nodejs_cleanup"]}"
    echo "Python Cleanup:      ${install_status["python_cleanup"]}"
    echo "Java Cleanup:        ${install_status["java_cleanup"]}"
    echo "Dependencies:        ${install_status["dependencies"]}"
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
    echo "🎉 Installation complete!"
    echo "Please restart your terminal or run: exec zsh"
    echo "================================================================"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi