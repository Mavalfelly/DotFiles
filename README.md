# Dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-Zsh-purple)](https://www.zsh.org/)
[![Editor](https://img.shields.io/badge/Editor-Neovim-green)](https://neovim.io/)

This repository contains configuration files and setup scripts for quickly provisioning a comprehensive development environment on Linux.

## Features

- **Automated Installation**: Fully automated setup with optional components and error handling
- **Modern Shell Experience**: Zsh with Zinit, syntax highlighting, autosuggestions, and 100+ aliases
- **Lightning Fast Editor**: Neovim with LazyVim configuration and curated plugins
- **Developer Tools**: fzf, ripgrep, fd, eza, bat, delta, and other modern CLI tools
- **Container Support**: Docker and Docker Compose with useful aliases
- **Database Tools**: PostgreSQL client with optimized configuration
- **Multi-Language Support**: Complete setup for Python, Node.js, Java, Rust, and Go
- **Beautiful Prompt**: Starship prompt with Git integration
- **Comprehensive Testing**: Full test suite to verify installation integrity
- **Performance Monitoring**: Built-in system monitoring and performance tools

## Quick Start

### First Time Setup

```bash
git clone https://github.com/Mavalfelly/DotFiles.git ~/.dotfiles && 
cd ~/.dotfiles && 
chmod +x install.sh && 
./install.sh
```

### Update Existing Installation

```bash
cd ~/.dotfiles &&
git checkout master &&
git pull origin master &&
./install.sh  # Cleans everything and reinstalls fresh
```

### Test Your Installation

```bash
cd ~/.dotfiles &&
./quick_test.sh              # Quick verification
./test_installation.sh        # Comprehensive validation
```

### Apply Changes

```bash
exec zsh  # Restart shell to apply all changes
```

## Installation Details

### What Gets Installed?

#### Core Development Environment
- **Zsh** with Zinit plugin manager
- **Starship** prompt with custom configuration
- **Neovim** with LazyVim setup
- **Git** with extensive aliases and GitHub CLI
- **Docker** and Docker Compose

#### Modern CLI Tools
- **File Management**: `eza`, `fd`, `ripgrep`, `fzf`
- **Viewing**: `bat`, `delta`, `btop`, `htop`
- **Development**: `watchexec`, `lsof`, `tree`

#### Programming Languages
- **Node.js** with npm, yarn, pnpm, TypeScript
- **Python** with pyenv and Poetry
- **Java** with SDKMAN
- **Rust** with rustup and cargo
- **Go** with standard toolchain

#### Database Tools
- **PostgreSQL** client with connection aliases
- Database management functions and scripts

### Installation Process

The installation is **fully optional** and **error-tolerant**:

1. **Backup Creation**: All existing configs are backed up with timestamp
2. **Step-by-Step**: Each component is installed independently
3. **Error Logging**: All errors are logged to timestamped files
4. **Continuation**: Installation continues even if individual steps fail
5. **Verification**: Comprehensive test suite validates everything

### Error Handling

- **Non-blocking**: Failed steps don't stop the entire installation
- **Detailed Logging**: All errors logged to `~/.dotfiles/install_YYYYMMDD_HHMMSS.log`
- **Graceful Degradation**: Partial installations still work
- **Post-install Testing**: Run test script to identify any issues

## Testing

Run the comprehensive test suite to verify your installation:

```bash
./test_installation.sh
```

### Test Categories

- **Quick Test**: Fast verification of core tools and configuration
- **Comprehensive Test**: Detailed validation of all components
- **Personal Removal Test**: Verifies no personal information remains

**Comprehensive Test Categories**:
- **Shell Setup**: Zsh, Zinit, aliases, functions
- **Terminal Tools**: All CLI tools functionality  
- **Development Tools**: Neovim, Git, editors
- **Language Runtimes**: Node.js, Python, Java, Rust, Go
- **Container Tools**: Docker functionality
- **Database Tools**: PostgreSQL client
- **Configurations**: All config files and environment variables
- **Security**: File permissions and sensitive data checks
- **Performance**: Startup times and tool response

## Customization

### Local Overrides

Create `~/.zshrc.local` for machine-specific customizations:

```bash
# Local customizations (won't be overridden by updates)
export CUSTOM_VAR="value"
alias local-command="some-command"

# Override project directory
export PROJECTS_DIR="$HOME/dev/projects"

# Override backup directory
export BACKUP_DIR="$HOME/backups"

# PostgreSQL configuration
export PGUSER="your_username"
export PGDATABASE="your_database"
```

### Project Templates

Use the `newproj` function to scaffold projects:

```bash
newproj python my-project          # Python with Poetry
newproj node my-project            # Node.js with npm
newproj react my-project           # React TypeScript
newproj rustapi my-project         # Rust API with Axum
newproj springboot my-project      # Spring Boot with PostgreSQL
```

### Custom Aliases

The `.zshrc` includes 100+ aliases for:

- **File Operations**: `ls`, `ll`, `la`, `tree` (with `eza`)
- **Git Workflow**: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`, etc.
- **Development**: `nv`, `vim`, `vi` (all map to Neovim)
- **Docker**: `d`, `dc`, `dps`, `dex`, `dlog`, etc.
- **PostgreSQL**: `pg-start`, `pg-stop`, `psql`, etc.
- **Navigation**: `..`, `...`, `proj`, `pj`, etc.

### Custom Functions

- **`project <name>`**: Navigate to and activate project environments (respects `$PROJECTS_DIR`)
- **`newproj <type> <name>`**: Scaffold new projects with templates (creates in `$PROJECTS_DIR`)
- **`pg_new <db>`**: Create new PostgreSQL database
- **`git_new <repo>`**: Create new GitHub repository (creates in `$PROJECTS_DIR`)
- **`perf_check`**: Comprehensive system performance report
- **`port_check <port>`**: Check if port is in use
- **`backup_projects`**: Backup all projects (saves to `$BACKUP_DIR`)

## Configuration Details

### Environment Variables

Key variables configured in `.zshrc` (can be customized):

```bash
export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.npm-global/bin:$PATH"
export BAT_THEME="GitHub"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export PROJECTS_DIR="$HOME/projects"  # Customize project directory
export BACKUP_DIR="$HOME/backups"     # Customize backup directory

# PostgreSQL (uncomment and customize as needed)
# export PGDATA="/var/lib/postgresql/16/main"
# export PGHOST="localhost"
# export PGPORT="5432"
# export PGUSER="$USER"
# export PGDATABASE="$USER"
```

### Zinit Plugins

- `zdharma-continuum/fast-syntax-highlighting`
- `zsh-users/zsh-autosuggestions`
- `marlonrichert/zsh-autocomplete`
- `hlissner/zsh-autopair`
- `MichaelAquilina/zsh-you-should-use`
- `djui/alias-tips`
- `wfxr/forgit`
- And many more...

### Neovim Configuration

Based on LazyVim with customizations for:
- Enhanced TypeScript/JavaScript support
- Python development with Poetry
- Rust development
- Git integration
- Database tools
- Custom keybindings

## Troubleshooting

### Common Issues

1. **Shell not changed**: Run `chsh -s $(which zsh)` manually
2. **Docker permission issues**: Add user to docker group: `sudo usermod -aG docker $USER`
3. **Node.js global packages**: Ensure `npm config set prefix "$HOME/.npm-global"`
4. **Python not found**: Restart shell or run `source ~/.zshrc`

### Logs and Debugging

- **Installation log**: `~/.dotfiles/install_YYYYMMDD_HHMMSS.log`
- **Test results**: `~/.dotfiles/test_results_YYYYMMDD_HHMMSS.log`
- **Zinit debug**: Run `zinit self-update` and `zinit delete --clean`

### Getting Help

1. Check the installation logs for errors
2. Run the test suite to identify issues
3. Check individual tool versions: `tool --version`
4. Restart shell: `exec zsh`

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly with the test suite
5. Submit a pull request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/your-username/DotFiles.git ~/.dotfiles-test
cd ~/.dotfiles-test

# Test your changes
./install.sh
./test_installation.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Zsh](https://www.zsh.org/) - The Z shell
- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager
- [Starship](https://starship.rs/) - Minimal prompt
- [Neovim](https://neovim.io/) - Vim-based editor
- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration
- [Eza](https://github.com/eza-community/eza) - Modern `ls`
- [Bat](https://github.com/sharkdp/bat) - `cat` with wings
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast search
- [fd](https://github.com/sharkdp/fd) - Fast find
- And all other amazing open-source tools used!

---