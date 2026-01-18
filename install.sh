#!/usr/bin/env bash
# ============================================================================
# DotFiles Installation Script
# ============================================================================
# Author: Matt Felly
# Repository: https://github.com/Mavalfelly/DotFiles
# License: MIT
# Last Modified: 2026-01-17
#
# This script assumes you've already cloned the dotfiles repo to ~/.dotfiles:
# git clone https://github.com/Mavalfelly/DotFiles.git ~/.dotfiles
#
# This script will automatically:
# 1. Clean existing configurations (with backups)
# 2. Install ZSH and set it as default shell
# 3. Install Neovim and development tools
# 4. Install Node.js, Python, Java, Rust, Go and their package managers
# 5. Install Docker and container tools
# 6. Install PostgreSQL client and tools
# 7. Configure all environment variables and paths
# 8. Set up the development environment from ~/.dotfiles
# 9. Handle errors gracefully and continue installation
# ============================================================================

set +e

TOTAL_STAGES=14
CURRENT_STAGE=0

LOG_FILE="$HOME/.dotfiles/install_$(date +%Y%m%d_%H%M%S).log"
echo "Installation log: $LOG_FILE"

log_error() {
    local stage="$1"
    local error_message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR in $stage: $error_message" >> "$LOG_FILE"
    echo "  ❌ Error logged to $LOG_FILE"
}

log_success() {
    local stage="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $stage completed successfully" >> "$LOG_FILE"
}

log_warning() {
    local stage="$1"
    local warning_message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING in $stage: $warning_message" >> "$LOG_FILE"
}

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
        return 0
    else
        echo "    ❌ Failed: $description"
        return 1
    fi
}

safe_execute() {
    local stage_name="$1"
    local function_to_call="$2"
    
    echo "▶ Running $stage_name..."
    if $function_to_call; then
        log_success "$stage_name"
        return 0
    else
        local exit_code=$?
        log_error "$stage_name" "Function exited with code $exit_code"
        echo "  ⚠️  $stage_name failed, but installation will continue..."
        return 1
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
        mkdir -p "$backup_dir" || {
            log_error "Shell cleanup" "Failed to create backup directory"
            return 1
        }

        [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$backup_dir/.zshrc" || true
        [[ -f "$HOME/.bashrc" ]] && cp "$HOME/.bashrc" "$backup_dir/.bashrc" || true
        [[ -f "$HOME/.profile" ]] && cp "$HOME/.profile" "$backup_dir/.profile" || true
        [[ -f "$HOME/.bash_profile" ]] && cp "$HOME/.bash_profile" "$backup_dir/.bash_profile" || true
        [[ -f "$HOME/.zshenv" ]] && cp "$HOME/.zshenv" "$backup_dir/.zshenv" || true
    fi

    rm -f "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile" "$HOME/.bash_logout" 2>/dev/null || true
    rm -f "$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zlogin" "$HOME/.zlogout" 2>/dev/null || true
    rm -f "$HOME/.inputrc" 2>/dev/null || true

    rm -rf "$HOME/.oh-my-zsh" 2>/dev/null || true
    rm -rf "$HOME/.antigen" 2>/dev/null || true
    rm -rf "$HOME/.zinit" 2>/dev/null || true
    rm -rf "$HOME/.zplug" 2>/dev/null || true
    rm -rf "$HOME/.zsh" 2>/dev/null || true
    
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

clean_rust() {
    echo "▶ Cleaning Rust installations and configurations..."
    
    sudo apt-get remove -y rustc cargo 2>/dev/null || true
    sudo apt-get autoremove -y
    
    rm -rf "$HOME/.cargo"
    rm -rf "$HOME/.rustup"
    
    unset CARGO_HOME
    unset RUSTUP_HOME
    
    echo "  Rust cleanup completed"
}

clean_go() {
    echo "▶ Cleaning Go installations and configurations..."
    
    sudo rm -rf /usr/local/go
    sudo rm -f /usr/local/bin/go
    
    unset GOPATH
    unset GOROOT
    
    echo "  Go cleanup completed"
}

install_dependencies() {
    echo "▶ Installing system packages..."
    if ! sudo apt update; then
        log_error "Dependencies" "Failed to update package lists"
        return 1
    fi
    
    sudo apt install -y zsh git curl wget fd-find ripgrep fzf htop tree btop || {
        log_warning "Dependencies" "Some system packages failed to install"
    }
    
    sudo apt install -y build-essential || {
        log_warning "Dependencies" "Build essentials failed to install"
    }

    echo "▶ Installing Starship prompt..."
    if ! curl -sS https://starship.rs/install.sh | sh -s -- -y; then
        log_error "Dependencies" "Starship installation failed"
        return 1
    fi

    echo "▶ Installing additional tools..."
    sudo apt install -y exa bat delta lsof watchexec || {
        log_warning "Dependencies" "Some additional tools failed to install"
    }

    echo "▶ Installing Python build dependencies..."
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev python3-dev || {
        log_warning "Dependencies" "Python build dependencies failed to install"
    }

    echo "▶ Installing Docker..."
    if sudo apt install -y ca-certificates curl gnupg lsb-release; then
        sudo mkdir -p /etc/apt/keyrings || true
        if curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg; then
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || true
            sudo apt update || true
            sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || {
                log_warning "Dependencies" "Docker installation failed"
            }
            sudo usermod -aG docker $USER || {
                log_warning "Dependencies" "Failed to add user to docker group"
            }
        else
            log_warning "Dependencies" "Docker GPG key setup failed"
        fi
    else
        log_warning "Dependencies" "Docker prerequisites failed"
    fi

    echo "▶ Installing PostgreSQL client..."
    sudo apt install -y postgresql-client || {
        log_warning "Dependencies" "PostgreSQL client failed to install"
    }

    echo "▶ Verifying dependencies..."
    run_test "ZSH is installed" "command -v zsh" || true
    run_test "Git is installed" "command -v git" || true
    run_test "curl is installed" "command -v curl" || true
    run_test "Starship is installed" "command -v starship" || true
    run_test "exa is installed" "command -v exa" || true
    run_test "bat is installed" "command -v bat" || true
    run_test "delta is installed" "command -v delta" || true
    run_test "docker is installed" "command -v docker" || true
    run_test "psql is installed" "command -v psql" || true
}

install_neovim() {
    echo "▶ Installing Neovim build dependencies..."
    if ! sudo apt-get install -y ninja-build gettext cmake unzip curl git build-essential; then
        log_error "Neovim" "Failed to install build dependencies"
        return 1
    fi

    echo "▶ Cloning Neovim repository..."
    rm -rf /tmp/neovim || true
    if ! git clone https://github.com/neovim/neovim /tmp/neovim; then
        log_error "Neovim" "Failed to clone repository"
        return 1
    fi
    cd /tmp/neovim || {
        log_error "Neovim" "Failed to change to neovim directory"
        return 1
    }

    echo "▶ Building Neovim from source..."
    if ! git checkout master; then
        log_warning "Neovim" "Failed to checkout master branch"
    fi
    
    if ! make CMAKE_BUILD_TYPE=Release; then
        log_error "Neovim" "Failed to build Neovim"
        cd -
        return 1
    fi
    
    if ! sudo make install; then
        log_error "Neovim" "Failed to install Neovim"
        cd -
        return 1
    fi
    cd -
    rm -rf /tmp/neovim

    echo "▶ Verifying Neovim installation..."
    run_test "Neovim is installed" "command -v nvim" || true
    run_test "Neovim version check" "nvim --version" || true

    echo "▶ Setting up LazyVim with custom config..."
    mkdir -p "$HOME/.config/nvim" || {
        log_error "Neovim" "Failed to create nvim config directory"
        return 1
    }

    rm -rf "$HOME/.config/nvim/.git" "$HOME/.config/nvim"/* 2>/dev/null || true
    if ! git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"; then
        log_error "Neovim" "Failed to clone LazyVim starter"
        return 1
    fi
    
    rm -rf "$HOME/.config/nvim/.git" || true

    if [ -d "$HOME/.dotfiles/.config/nvim" ]; then
        echo "  Copying custom Neovim config from ~/.dotfiles"
        cp -r "$HOME/.dotfiles/.config/nvim/"* "$HOME/.config/nvim/" || {
            log_warning "Neovim" "Failed to copy custom config"
        }
    else
        echo "  No custom Neovim config found in ~/.dotfiles/.config/nvim"
    fi

    echo "LazyVim setup complete. First run will install plugins automatically."
}

setup_zsh() {
    echo "▶ Checking current shell..."
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "▶ Setting ZSH as default shell..."
        if ! chsh -s $(which zsh); then
            log_error "ZSH setup" "Failed to set ZSH as default shell"
            return 1
        fi
    else
        echo "▶ ZSH is already the default shell"
    fi
    run_test "Default shell is ZSH" "[ \"$SHELL\" = \"$(which zsh)\" ]" || true
}

install_node() {
    echo "▶ Installing Node.js from NodeSource repository..."
    
    if ! curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -; then
        log_error "Node.js" "Failed to add NodeSource repository"
        return 1
    fi
    
    if ! sudo apt-get install -y nodejs; then
        log_error "Node.js" "Failed to install Node.js"
        return 1
    fi
    
    echo "▶ Configuring npm for global packages..."
    
    mkdir -p "$HOME/.npm-global" || {
        log_error "Node.js" "Failed to create npm-global directory"
        return 1
    }
    
    npm config set prefix "$HOME/.npm-global" || {
        log_warning "Node.js" "Failed to set npm prefix"
    }
    
    export PATH="$HOME/.npm-global/bin:$PATH"
    
    echo "▶ Installing global npm packages..."
    npm install -g yarn pnpm typescript ts-node || {
        log_warning "Node.js" "Some npm packages failed to install"
    }
    
    echo "▶ Verifying Node.js installations..."
    run_test "Node.js is installed" "command -v node" || true
    run_test "npm is installed" "command -v npm" || true
    run_test "Yarn is installed" "command -v yarn" || true
    run_test "pnpm is installed" "command -v pnpm" || true
    run_test "TypeScript is installed" "command -v tsc" || true
    
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

install_rust() {
    echo "▶ Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    
    run_test "Rust is installed" "command -v cargo"
    run_test "rustc is installed" "command -v rustc"
    
    echo "✅ Rust installation completed successfully!"
}

install_go() {
    echo "▶ Installing Go..."
    local go_version="1.21.5"
    wget "https://golang.org/dl/go${go_version}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${go_version}.linux-amd64.tar.gz"
    rm "go${go_version}.linux-amd64.tar.gz"
    
    run_test "Go is installed" "command -v go"
    
    echo "✅ Go installation completed successfully!"
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

    if [ -f "$HOME/.dotfiles/.config/starship.toml" ]; then
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
    if safe_execute "Shell Cleanup" "clean_shell_configs"; then
        install_status["shell_cleanup"]="✓ Success"
    else
        install_status["shell_cleanup"]="⚠ Partial (continuing)"
    fi
    
    print_stage "CLEANING NEOVIM"
    if safe_execute "Neovim Cleanup" "clean_neovim"; then
        install_status["neovim_cleanup"]="✓ Success"
    else
        install_status["neovim_cleanup"]="⚠ Partial (continuing)"
    fi
    
    print_stage "CLEANING NODE.JS"
    if safe_execute "Node.js Cleanup" "clean_nodejs"; then
        install_status["nodejs_cleanup"]="✓ Success"
    else
        install_status["nodejs_cleanup"]="⚠ Partial (continuing)"
    fi
    
    print_stage "CLEANING PYTHON"
    if safe_execute "Python Cleanup" "clean_python"; then
        install_status["python_cleanup"]="✓ Success"
    else
        install_status["python_cleanup"]="⚠ Partial (continuing)"
    fi
    
    print_stage "CLEANING JAVA"
    if safe_execute "Java Cleanup" "clean_java"; then
        install_status["java_cleanup"]="✓ Success"
    else
        install_status["java_cleanup"]="⚠ Partial (continuing)"
    fi
    
    print_stage "CLEANING RUST"
    if safe_execute "Rust Cleanup" "clean_rust"; then
        install_status["rust_cleanup"]="✓ Success"
    else
        install_status["rust_cleanup"]="⚠ Partial (continuing)"
    fi
    
    print_stage "CLEANING GO"
    if safe_execute "Go Cleanup" "clean_go"; then
        install_status["go_cleanup"]="✓ Success"
    else
        install_status["go_cleanup"]="⚠ Partial (continuing)"
    fi
    
    print_stage "INSTALLING DEPENDENCIES"
    if safe_execute "Dependencies Installation" "install_dependencies"; then
        install_status["dependencies"]="✓ Success"
    else
        install_status["dependencies"]="⚠ Partial (continuing)"
    fi
    
    print_stage "INSTALLING NEOVIM"
    if safe_execute "Neovim Installation" "install_neovim"; then
        install_status["neovim"]="✓ Success"
    else
        install_status["neovim"]="⚠ Partial (continuing)"
    fi
    
    print_stage "SETTING UP ZSH"
    if safe_execute "ZSH Setup" "setup_zsh"; then
        install_status["zsh"]="✓ Success"
    else
        install_status["zsh"]="⚠ Partial (continuing)"
    fi
    
    print_stage "INSTALLING NODE.JS"
    if safe_execute "Node.js Installation" "install_node"; then
        install_status["node"]="✓ Success"
    else
        install_status["node"]="⚠ Partial (continuing)"
    fi
    
    print_stage "INSTALLING PYTHON"
    if safe_execute "Python Installation" "install_python"; then
        install_status["python"]="✓ Success"
    else
        install_status["python"]="⚠ Partial (continuing)"
    fi
    
    print_stage "INSTALLING JAVA"
    if safe_execute "Java Installation" "install_java"; then
        install_status["java"]="✓ Success"
    else
        install_status["java"]="⚠ Partial (continuing)"
    fi
    
    print_stage "INSTALLING RUST"
    if safe_execute "Rust Installation" "install_rust"; then
        install_status["rust"]="✓ Success"
    else
        install_status["rust"]="⚠ Partial (continuing)"
    fi
    
    print_stage "INSTALLING GO"
    if safe_execute "Go Installation" "install_go"; then
        install_status["go"]="✓ Success"
    else
        install_status["go"]="⚠ Partial (continuing)"
    fi
    
    print_stage "SETTING UP DOTFILES"
    if safe_execute "Dotfiles Setup" "setup_dotfiles"; then
        install_status["dotfiles"]="✓ Success"
    else
        install_status["dotfiles"]="⚠ Partial (continuing)"
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
    echo "Rust Cleanup:        ${install_status["rust_cleanup"]}"
    echo "Go Cleanup:          ${install_status["go_cleanup"]}"
    echo "Dependencies:        ${install_status["dependencies"]}"
    echo "Neovim:              ${install_status["neovim"]}"
    echo "Zsh:                 ${install_status["zsh"]}"
    echo "Node.js:             ${install_status["node"]}"
    echo "Python:              ${install_status["python"]}"
    echo "Java:                ${install_status["java"]}"
    echo "Rust:                ${install_status["rust"]}"
    echo "Go:                  ${install_status["go"]}"
    echo "Dotfiles:            ${install_status["dotfiles"]}"
    echo "----------------------------------------------------------------"
    echo "Total Duration:      ${duration} seconds"
    echo "Installation Log:    $LOG_FILE"
    echo "Test Script:         $HOME/.dotfiles/test_installation.sh"
    echo "----------------------------------------------------------------"
    echo
    echo "🎉 Installation complete!"
    echo "💡 Run './test_installation.sh' to verify your installation"
    echo "🔄 Please restart your terminal or run: exec zsh"
    echo "📋 Check logs at: $LOG_FILE for any issues"
    echo "================================================================"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi