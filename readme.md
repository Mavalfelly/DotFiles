# Dotfiles

This repository contains configuration files and setup scripts for quickly provisioning a development environment on Linux.

## Features

- **Zsh** configuration with plugins (autosuggestions, syntax highlighting, completions, etc.)
- **Neovim** setup using [LazyVim](https://github.com/LazyVim/LazyVim) and a curated plugin list
- **fzf**, **ripgrep**, **fd**, and other CLI tools
- Language environment setup for Python, Node.js, and Java
- Custom aliases, environment variables, and prompt
- Automated install script for bootstrapping a new machine

## Quick Start

1. **Clone this repository:**
   ```sh
   git clone https://github.com/Mavalfelly/DotFiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the install script:**
   ```sh
   ./install.sh
   ```

   This will:
   - Install dependencies (zsh, neovim, fzf, etc.)
   - Set up symlinks for config files
   - Install language managers (nvm, pyenv, sdkman)
   - Configure your shell and editor

3. **Restart your shell** to apply changes.

## Structure

- `.zshrc` — Zsh configuration
- `.config/nvim/` — Neovim config (see its [README](.config/nvim/README.md))
- `install.sh` — Main setup script
- `.config/` — Other app configs (e.g., stylua, etc.)

## Customization

- Place device-specific overrides in `~/.zshrc.local`
- Update plugin lists and aliases as needed
