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

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Default editor and pager
export EDITOR="nvim"                    # Default text editor
export VISUAL="nvim"                    # Visual editor
export PAGER="less"                     # Default pager
# export BROWSER="firefox"              # Default web browser
# export TERMINAL="alacritty"           # Default terminal emulator

# Language and locale settings
export LANG="en_US.UTF-8"              # System language
export LC_ALL="en_US.UTF-8"            # All locale categories
# export LC_COLLATE="C"                 # Sort order (C = ASCII order)
# export LC_TIME="en_US.UTF-8"          # Time format

# Path configuration
export PATH="$HOME/.local/bin:$PATH"                    # Local binaries
# export PATH="/usr/local/bin:$PATH"                    # Local system binaries
# export PATH="/opt/homebrew/bin:$PATH"                 # Homebrew (macOS)

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"          # Configuration files
export XDG_DATA_HOME="$HOME/.local/share"       # Data files
export XDG_CACHE_HOME="$HOME/.cache"            # Cache files
export XDG_STATE_HOME="$HOME/.local/state"      # State files

# ============================================================================
# DEVELOPMENT ENVIRONMENT - JAVASCRIPT/NODE.JS
# ============================================================================
# Installation:
# Node.js via NodeSource: curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs
# Yarn: npm install -g yarn
# pnpm: npm install -g pnpm

# Node.js environment
export PATH="$HOME/.npm-global/bin:$PATH"       # npm global packages
# export NODE_ENV="development"                  # Default Node environment
# export NODE_OPTIONS="--max-old-space-size=4096"  # Increase Node.js memory limit

# npm configuration
export NPM_CONFIG_PREFIX="$HOME/.npm-global"    # Global npm packages location

# JavaScript/TypeScript aliases
alias npm-list-global='npm list -g --depth=0'   # List global npm packages
alias npm-update-global='npm update -g'         # Update global npm packages
alias yarn-list-global='yarn global list'       # List global yarn packages
alias pnpm-list-global='pnpm list -g'          # List global pnpm packages
alias node-version='node --version && npm --version'  # Show Node.js versions

# ============================================================================
# DEVELOPMENT ENVIRONMENT - PYTHON
# ============================================================================
# Installation:
# Python: sudo apt install python3 python3-pip python3-venv python3-dev
# pyenv: curl https://pyenv.run | bash
# Poetry: curl -sSL https://install.python-poetry.org | python3 -
# pipx: python3 -m pip install --user pipx && python3 -m pipx ensurepath

# Python environment
export PYTHONPATH="$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH"  # Python path
export PIP_USER=1                       # Install pip packages to user directory
export PIPENV_VENV_IN_PROJECT=1        # Create .venv in project directory

# pyenv - Python Version Manager
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"                # Initialize pyenv
  eval "$(pyenv virtualenv-init -)"     # Initialize pyenv-virtualenv
fi

# Poetry - Python Package Manager
export PATH="$HOME/.local/bin:$PATH"    # Poetry installation path
if command -v poetry &> /dev/null; then
  # Poetry completions are loaded via plugin
  export POETRY_VENV_IN_PROJECT=1       # Create .venv in project directory
fi

# Python aliases
alias py='python3'                      # Python 3 shorthand
alias pip='pip3'                        # Use pip3 by default
alias venv='python3 -m venv'           # Create virtual environment
alias activate='source venv/bin/activate'  # Activate venv (if in project root)
alias serve='python3 -m http.server'   # Simple HTTP server
alias json='python3 -m json.tool'      # Pretty print JSON
alias pyserver='python3 -m http.server 8000'  # HTTP server on port 8000

# ============================================================================
# DEVELOPMENT ENVIRONMENT - JAVA
# ============================================================================
# Installation:
# OpenJDK: sudo apt install openjdk-17-jdk openjdk-17-jre
# SDKMAN: curl -s "https://get.sdkman.io" | bash
# Maven: sudo apt install maven
# Gradle: sudo apt install gradle

# Java environment
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"  # Adjust path for your system
export PATH="$JAVA_HOME/bin:$PATH"

# SDKMAN - Java/JVM Tool Manager
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Maven configuration
export M2_HOME="/usr/share/maven"       # Maven home
export MAVEN_HOME="$M2_HOME"           # Maven home alias
export PATH="$M2_HOME/bin:$PATH"       # Maven binaries

# Gradle configuration  
export GRADLE_HOME="/usr/share/gradle" # Gradle home
export PATH="$GRADLE_HOME/bin:$PATH"   # Gradle binaries

# Java aliases
alias java-version='java -version && javac -version'  # Show Java versions
alias maven-version='mvn -version'     # Show Maven version
alias gradle-version='gradle -version' # Show Gradle version
alias java-list='ls $JAVA_HOME'       # List Java installation
alias mvn-clean='mvn clean compile'    # Maven clean compile
alias mvn-test='mvn clean test'        # Maven clean test
alias mvn-package='mvn clean package'  # Maven clean package
alias gradle-build='gradle clean build' # Gradle clean build
alias gradle-test='gradle clean test'  # Gradle clean test

# ============================================================================
# ZSH HISTORY CONFIGURATION
# ============================================================================

HISTFILE=~/.histfile                           # History file location
HISTSIZE=50000                                 # History size in memory
SAVEHIST=50000                                 # History size on disk

# History behavior options
setopt HIST_IGNORE_DUPS                # Don't record consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS            # Delete old duplicate entries
setopt HIST_FIND_NO_DUPS               # Don't display duplicates during search
setopt HIST_IGNORE_SPACE               # Don't record entries starting with space
setopt HIST_SAVE_NO_DUPS               # Don't write duplicates to history file
setopt HIST_REDUCE_BLANKS              # Remove superfluous blanks
setopt HIST_VERIFY                     # Show command with history expansion
setopt SHARE_HISTORY                   # Share history between sessions
setopt APPEND_HISTORY                  # Append to history file
setopt INC_APPEND_HISTORY             # Write to history file immediately

# ============================================================================
# ZSH OPTIONS AND BEHAVIOR
# ============================================================================

# --- Directory Navigation ---
setopt AUTO_CD                         # Just type directory name to cd
setopt AUTO_PUSHD                      # Push directories onto stack automatically
setopt PUSHD_IGNORE_DUPS              # Don't push duplicate directories
setopt PUSHD_SILENT                   # Don't print directory stack after pushd/popd
setopt CDABLE_VARS                    # Allow cd to variable names

# --- Completion System ---
setopt AUTO_LIST                      # List choices on ambiguous completion
setopt AUTO_MENU                      # Use menu completion after second tab
setopt COMPLETE_IN_WORD               # Complete from both ends of word
setopt ALWAYS_TO_END                  # Move cursor to end after completion
setopt LIST_PACKED                    # Compact completion lists
setopt LIST_TYPES                     # Show file types in completion

# --- Globbing and Pattern Matching ---
setopt EXTENDED_GLOB                  # Use extended globbing syntax
setopt GLOB_DOTS                      # Include dotfiles in globbing
setopt NUMERIC_GLOB_SORT              # Sort numeric filenames numerically

# --- Job Control ---
setopt AUTO_RESUME                    # Single word commands resume jobs
setopt LONG_LIST_JOBS                 # List jobs in long format
setopt NOTIFY                         # Report job status immediately

# --- Input/Output ---
setopt CORRECT                        # Spell correction for commands
setopt CORRECT_ALL                    # Spell correction for all arguments
setopt INTERACTIVE_COMMENTS           # Allow comments in interactive shell
setopt RC_QUOTES                      # Allow '' to represent single quote in strings
setopt SHORT_LOOPS                    # Allow short forms of for/repeat/select

# --- Prompt and Terminal ---
setopt PROMPT_SUBST                   # Allow parameter expansion in prompts
setopt TRANSIENT_RPROMPT              # Remove right prompt after command

# --- Key Bindings ---
bindkey -e                           # Use Emacs key bindings

# ============================================================================
# COMPLETION SYSTEM SETUP
# ============================================================================

# Load and initialize completion system
autoload -Uz compinit
compinit

# Completion styles
zstyle ':completion:*' menu select                    # Use menu for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # Use colors in completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # Case insensitive matching
zstyle ':completion:*' completer _expand _complete _correct _approximate  # Completion strategies
zstyle ':completion:*' format 'Completing %d'        # Completion group format
zstyle ':completion:*' group-name ''                 # Group completions
zstyle ':completion:*' verbose yes                   # Verbose completions

# ============================================================================
# ALIASES
# ============================================================================

# --- Basic Commands ---
alias ls='ls --color=auto'            # Colorized ls
alias ll='ls -lah'                    # Long list with hidden files
alias la='ls -A'                      # List all except . and ..
alias l='ls -CF'                      # Classify files
alias grep='grep --color=auto'        # Colorized grep
alias fgrep='fgrep --color=auto'      # Colorized fgrep
alias egrep='egrep --color=auto'      # Colorized egrep

# --- Navigation ---
alias ..='cd ..'                      # Go up one directory
alias ...='cd ../..'                  # Go up two directories
alias ....='cd ../../..'              # Go up three directories
alias .....='cd ../../../..'          # Go up four directories

# --- Git Aliases ---
alias gs='git status'                 # Git status
alias ga='git add'                    # Git add
alias gc='git commit'                 # Git commit
alias gp='git push'                   # Git push
alias gl='git pull'                   # Git pull
alias gd='git diff'                   # Git diff
alias gb='git branch'                 # Git branch
alias gco='git checkout'              # Git checkout
alias glog='git log --oneline --graph'  # Pretty git log

# --- System Utilities ---
alias df='df -h'                      # Human readable df
alias du='du -h'                      # Human readable du
alias free='free -h'                  # Human readable free
alias ps='ps aux'                     # Detailed process list
alias top='htop'                      # Use htop instead of top
alias tree='tree -C'                  # Colorized tree

# --- Editor Aliases ---
alias vim='nvim'                      # Use neovim
alias vi='nvim'                       # Use neovim

# ============================================================================
# FUNCTIONS
# ============================================================================

# --- Git status prompt helper ---
git_prompt_info() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    local dirty=$(git status --porcelain 2>/dev/null)
    local bgcolor symbol
    if [[ -n $dirty ]]; then
      bgcolor='%K{red}'          # Red bg for dirty repo
      symbol='%F{white}✗%f'       # White X
    else
      bgcolor='%K{green}'        # Green bg clean repo
      symbol='%F{black}✓%f'       # Black checkmark
    fi
    echo "%F{blue}%f%F{white}%B $branch %b%f%K{black}%f${bgcolor} $symbol %k"
  else
    echo ""
  fi
}

# --- Command duration measurement ---
autoload -Uz add-zsh-hook

preexec() {
  # Called before executing a command
  CMD_START_TIME=$(date +%s%3N)  # milliseconds
}

precmd() {
  # Called before showing prompt
  if [[ -n $CMD_START_TIME ]]; then
    local now=$(date +%s%3N)
    local elapsed_ms=$(( now - CMD_START_TIME ))
    CMD_DURATION=$elapsed_ms
  else
    CMD_DURATION=0
  fi
  unset CMD_START_TIME
}

add-zsh-hook preexec preexec
add-zsh-hook precmd precmd

# --- Format last command duration ---
last_cmd_duration() {
  if [[ -n $CMD_DURATION && $CMD_DURATION -gt 0 ]]; then
    local ms=$CMD_DURATION
    local sec=$(( ms / 1000 ))
    local rem_ms=$(( ms % 1000 ))

    if (( sec > 59 )); then
      local min=$(( sec / 60 ))
      sec=$(( sec % 60 ))
      printf "⏱ %dm%02ds" $min $sec
    elif (( sec > 0 )); then
      printf "⏱ %ds" $sec
    else
      printf "⏱ %dms" $ms
    fi
  fi
}

# --- Show last command exit status ---
last_cmd_status() {
  local code=$?
  if (( code == 0 )); then
    echo "%F{green}✔%f"
  else
    echo "%F{red}✘($code)%f"
  fi
}

# --- Development utility functions ---

# Extract various archive formats
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Make directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find process by name
psg() {
  ps aux | grep -v grep | grep "$@" -i --color=always
}

# ============================================================================
# PROMPT CONFIGURATION
# ============================================================================

setopt PROMPT_SUBST

PROMPT=''

# Current time in 24h format HH:MM:SS with magenta background
PROMPT+='%F{black}%K{magenta} %* %k%f '

# Current directory in bold cyan
PROMPT+='%F{cyan}%B %~ %b%f '

# Git info block
PROMPT+='$(git_prompt_info) '

# Last command duration
PROMPT+='$(last_cmd_duration) '

# Last command exit status
PROMPT+='$(last_cmd_status) '

# Arrow prompt in green
PROMPT+='%F{green}➜ %f'

# ============================================================================
# ZINIT PLUGIN MANAGER SETUP
# ============================================================================
# Installation: sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Install Zinit if not already installed
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# ============================================================================
# PLUGIN CONFIGURATION
# ============================================================================

# --- Essential Productivity Plugins ---
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions      # Fish-like autosuggestions

zinit ice wait"0"
zinit light zsh-users/zsh-syntax-highlighting  # Syntax highlighting

zinit light zsh-users/zsh-history-substring-search  # History search with arrows
zinit light zsh-users/zsh-completions         # Additional completions
zinit light rupa/z                            # Jump to directories (z command)
zinit light tarrasch/zsh-autoenv              # Auto source .env files
zinit light mafredri/zsh-async                # Async functions

# --- Load Zinit annexes ---
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Initialize completion system for zinit
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ============================================================================
# ADDITIONAL TOOL CONFIGURATIONS
# ============================================================================

# --- FZF Configuration ---
# Installation: sudo apt install fzf || brew install fzf
if command -v fzf &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# ============================================================================
# KEY BINDINGS
# ============================================================================

# History substring search bindings
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
bindkey -M emacs '^P' history-substring-search-up    # Ctrl-P
bindkey -M emacs '^N' history-substring-search-down  # Ctrl-N

# ============================================================================
# DEVICE-SPECIFIC CONFIGURATION
# ============================================================================

# Load device-specific configuration if it exists
# This file should contain device-specific settings like:
# - Different Java/Python/Node versions
# - Device-specific paths
# - Custom environment variables
# - Local development settings
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

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