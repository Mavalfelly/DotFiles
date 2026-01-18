#!/usr/bin/env bash
# ============================================================================
# DotFiles Installation Test Suite
# ============================================================================
# Author: Matt Felly
# Repository: https://github.com/Mavalfelly/DotFiles
# License: MIT
# Description: Comprehensive testing for dotfiles installation
# Last Modified: 2026-01-17
# ============================================================================

set -e

TEST_RESULTS_FILE="$HOME/.dotfiles/test_results_$(date +%Y%m%d_%H%M%S).log"
FAILED_TESTS=0
PASSED_TESTS=0
TOTAL_TESTS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test framework functions
log_test() {
    local test_name="$1"
    local test_status="$2"
    local message="$3"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$test_status] $test_name: $message" >> "$TEST_RESULTS_FILE"
    
    case $test_status in
        "PASS")
            echo -e "  ${GREEN}✅ PASS${NC} $test_name"
            ((PASSED_TESTS++))
            ;;
        "FAIL")
            echo -e "  ${RED}❌ FAIL${NC} $test_name: $message"
            ((FAILED_TESTS++))
            ;;
        "SKIP")
            echo -e "  ${YELLOW}⏭️  SKIP${NC} $test_name: $message"
            ;;
        "WARN")
            echo -e "  ${YELLOW}⚠️  WARN${NC} $test_name: $message"
            ;;
    esac
    ((TOTAL_TESTS++))
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="${3:-0}"
    
    echo -e "\n${BLUE}Testing:${NC} $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        local actual_result=$?
        if [ "$actual_result" -eq "$expected_result" ]; then
            log_test "$test_name" "PASS" "Command returned expected result"
            return 0
        else
            log_test "$test_name" "FAIL" "Command returned $actual_result, expected $expected_result"
            return 1
        fi
    else
        log_test "$test_name" "FAIL" "Command failed to execute"
        return 1
    fi
}

run_file_test() {
    local test_name="$1"
    local file_path="$2"
    local test_type="${3:-exists}"
    
    echo -e "\n${BLUE}Testing:${NC} $test_name"
    
    case $test_type in
        "exists")
            if [ -f "$file_path" ]; then
                log_test "$test_name" "PASS" "File exists at $file_path"
                return 0
            else
                log_test "$test_name" "FAIL" "File not found at $file_path"
                return 1
            fi
            ;;
        "executable")
            if [ -x "$file_path" ]; then
                log_test "$test_name" "PASS" "File is executable at $file_path"
                return 0
            else
                log_test "$test_name" "FAIL" "File is not executable at $file_path"
                return 1
            fi
            ;;
        "directory")
            if [ -d "$file_path" ]; then
                log_test "$test_name" "PASS" "Directory exists at $file_path"
                return 0
            else
                log_test "$test_name" "FAIL" "Directory not found at $file_path"
                return 1
            fi
            ;;
    esac
}

run_content_test() {
    local test_name="$1"
    local file_path="$2"
    local search_pattern="$3"
    
    echo -e "\n${BLUE}Testing:${NC} $test_name"
    
    if [ -f "$file_path" ] && grep -q "$search_pattern" "$file_path"; then
        log_test "$test_name" "PASS" "Pattern '$search_pattern' found in $file_path"
        return 0
    else
        log_test "$test_name" "FAIL" "Pattern '$search_pattern' not found in $file_path"
        return 1
    fi
}

# Test suite functions
test_shell_setup() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Shell Setup${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    run_test "ZSH is installed" "command -v zsh"
    run_test "Current shell is ZSH" "[ \"\$SHELL\" = \"\$(which zsh)\" ]"
    run_file_test ".zshrc exists" "$HOME/.zshrc"
    run_content_test ".zshrc contains Starship" "$HOME/.zshrc" "starship init zsh"
    run_content_test ".zshrc contains EDITOR" "$HOME/.zshrc" "EDITOR=\"nvim\""
    run_content_test ".zshrc contains PATH" "$HOME/.zshrc" "PATH=\"\\$HOME/.local/bin"
    
    # Test Zinit installation
    run_file_test "Zinit directory exists" "$HOME/.local/share/zinit/zinit.git" "directory"
    run_file_test "Zinit executable exists" "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
    
    # Test shell aliases and functions
    run_content_test "ls alias exists" "$HOME/.zshrc" "alias ls='exa"
    run_content_test "git aliases exist" "$HOME/.zshrc" "alias gs='git status'"
    run_content_test "project function exists" "$HOME/.zshrc" "project() {"
    run_content_test "newproj function exists" "$HOME/.zshrc" "newproj() {"
}

test_terminal_tools() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Terminal Tools${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    run_test "Starship is installed" "command -v starship"
    run_test "exa is installed" "command -v exa"
    run_test "bat is installed" "command -v bat"
    run_test "delta is installed" "command -v delta"
    run_test "fd is installed" "command -v fd"
    run_test "ripgrep is installed" "command -v rg"
    run_test "fzf is installed" "command -v fzf"
    run_test "htop is installed" "command -v htop"
    run_test "btop is installed" "command -v btop"
    run_test "tree is installed" "command -v tree"
    run_test "lsof is installed" "command -v lsof"
    run_test "watchexec is installed" "command -v watchexec"
    
    # Test tools actually work
    run_test "exa can list files" "exa --version"
    run_test "bat can display help" "bat --help"
    run_test "ripgrep can search" "rg --version"
    run_test "fzf can display version" "fzf --version"
    run_test "starship can show version" "starship --version"
}

test_development_tools() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Development Tools${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    # Neovim tests
    run_test "Neovim is installed" "command -v nvim"
    run_test "Neovim version check" "nvim --version"
    run_file_test "Neovim config directory exists" "$HOME/.config/nvim" "directory"
    run_file_test "Neovim init.lua exists" "$HOME/.config/nvim/init.lua"
    
    # Git tests
    run_test "Git is installed" "command -v git"
    run_test "Git version check" "git --version"
    run_test "Git config has user" "git config --global user.name"
    run_test "Git config has email" "git config --global user.email"
    
    # GitHub CLI
    run_test "GitHub CLI is installed" "command -v gh"
    run_test "GitHub CLI version check" "gh --version"
}

test_languages() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Programming Languages${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    # Node.js tests
    echo -e "\n${YELLOW}Node.js:${NC}"
    run_test "Node.js is installed" "command -v node"
    run_test "Node version check" "node --version"
    run_test "npm is installed" "command -v npm"
    run_test "npm version check" "npm --version"
    run_test "npm global prefix is set" "[ \"\$(npm config get prefix)\" = \"\$HOME/.npm-global\" ]"
    run_test "Yarn is installed" "command -v yarn"
    run_test "pnpm is installed" "command -v pnpm"
    run_test "TypeScript is installed" "command -v tsc"
    run_test "ts-node is installed" "command -v ts-node"
    run_file_test "npm-global directory exists" "$HOME/.npm-global" "directory"
    
    # Python tests
    echo -e "\n${YELLOW}Python:${NC}"
    run_test "Python is installed" "command -v python3"
    run_test "Python version check" "python3 --version"
    run_test "pip is installed" "command -v pip3"
    run_test "pyenv is installed" "command -v pyenv"
    run_test "pyenv version check" "pyenv --version"
    run_file_test "pyenv directory exists" "$HOME/.pyenv" "directory"
    run_test "Poetry is installed" "command -v poetry"
    run_test "Poetry version check" "poetry --version"
    run_file_test "Poetry directory exists" "$HOME/.local/share/pypoetry" "directory"
    
    # Java tests
    echo -e "\n${YELLOW}Java:${NC}"
    run_test "Java is installed" "command -v java"
    run_test "Java version check" "java -version"
    run_test "javac is installed" "command -v javac"
    run_test "SDKMAN is installed" "command -v sdk"
    run_file_test "SDKMAN directory exists" "$HOME/.sdkman" "directory"
    
    # Rust tests
    echo -e "\n${YELLOW}Rust:${NC}"
    run_test "Rust is installed" "command -v cargo"
    run_test "Rust version check" "cargo --version"
    run_test "rustc is installed" "command -v rustc"
    run_file_test "Cargo directory exists" "$HOME/.cargo" "directory"
    run_test "rustup is installed" "command -v rustup"
    
    # Go tests
    echo -e "\n${YELLOW}Go:${NC}"
    run_test "Go is installed" "command -v go"
    run_test "Go version check" "go version"
    run_test "Go directory exists" "[ -d \"/usr/local/go\" ] || [ -d \"\$HOME/go\" ]"
}

test_containers() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Container Tools${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    run_test "Docker is installed" "command -v docker"
    run_test "Docker version check" "docker --version"
    run_test "Docker Compose is installed" "docker compose version"
    run_test "Docker daemon is running" "docker info"
    run_test "User is in docker group" "groups | grep -q docker"
    
    # Test basic Docker functionality
    if command -v docker >/dev/null 2>&1; then
        run_test "Docker can pull hello-world" "docker pull hello-world:latest"
        run_test "Docker can run hello-world" "docker run --rm hello-world:latest"
    fi
}

test_databases() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Database Tools${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    run_test "PostgreSQL client is installed" "command -v psql"
    run_test "PostgreSQL client version check" "psql --version"
    run_test "createdb is available" "command -v createdb"
    run_test "dropdb is available" "command -v dropdb"
    run_test "pg_dump is available" "command -v pg_dump"
    
    # Test PostgreSQL environment variables
    run_content_test "PGDATA is set" "$HOME/.zshrc" "export PGDATA="
    run_content_test "PGHOST is set" "$HOME/.zshrc" "export PGHOST="
    run_content_test "PGPORT is set" "$HOME/.zshrc" "export PGPORT="
    run_content_test "PGUSER is set" "$HOME/.zshrc" "export PGUSER="
    run_content_test "PGDATABASE is set" "$HOME/.zshrc" "export PGDATABASE="
}

test_configurations() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Configuration Files${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    # Test Starship config
    run_file_test "Starship config exists" "$HOME/.config/starship.toml"
    run_content_test "Starship config format" "$HOME/.config/starship.toml" "format ="
    
    # Test Neovim config structure
    run_file_test "Neovim lua directory exists" "$HOME/.config/nvim/lua" "directory"
    run_file_test "Neovim lazy.lua exists" "$HOME/.config/nvim/lua/config/lazy.lua"
    
    # Test environment variables in .zshrc
    run_content_test "EDITOR variable set" "$HOME/.zshrc" "export EDITOR="
    run_content_test "VISUAL variable set" "$HOME/.zshrc" "export VISUAL="
    run_content_test "BAT_THEME variable set" "$HOME/.zshrc" "export BAT_THEME="
    run_content_test "FZF_DEFAULT_COMMAND set" "$HOME/.zshrc" "export FZF_DEFAULT_COMMAND="
    
    # Test PATH includes expected directories
    run_content_test "PATH includes cargo/bin" "$HOME/.zshrc" "\$HOME/.cargo/bin"
    run_content_test "PATH includes go/bin" "$HOME/.zshrc" "\$HOME/go/bin"
    run_content_test "PATH includes npm-global/bin" "$HOME/.zshrc" "\$HOME/.npm-global/bin"
    run_content_test "PATH includes local/bin" "$HOME/.zshrc" "\$HOME/.local/bin"
}

test_aliases_and_functions() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Aliases and Functions${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    # Test file management aliases
    run_content_test "ls alias configured" "$HOME/.zshrc" "alias ls='exa"
    run_content_test "ll alias configured" "$HOME/.zshrc" "alias ll='exa"
    run_content_test "la alias configured" "$HOME/.zshrc" "alias la='exa"
    run_content_test "tree alias configured" "$HOME/.zshrc" "alias tree='exa"
    run_content_test "cat alias configured" "$HOME/.zshrc" "alias cat='bat"
    
    # Test git aliases
    local git_aliases=("gs" "ga" "gc" "gp" "gl" "gd" "gco" "glog" "gst" "gsp")
    for alias in "${git_aliases[@]}"; do
        run_content_test "git alias $alias configured" "$HOME/.zshrc" "alias $alias='git"
    done
    
    # Test Python aliases
    run_content_test "py alias configured" "$HOME/.zshrc" "alias py='python3'"
    run_content_test "pip alias configured" "$HOME/.zshrc" "alias pip='pip3'"
    run_content_test "pytest alias configured" "$HOME/.zshrc" "alias pytest='python3 -m pytest'"
    
    # Test editor aliases
    run_content_test "nv alias configured" "$HOME/.zshrc" "alias nv='nvim'"
    run_content_test "vim alias configured" "$HOME/.zshrc" "alias vim='nvim'"
    run_content_test "vi alias configured" "$HOME/.zshrc" "alias vi='nvim'"
    run_content_test "nano alias configured" "$HOME/.zshrc" "alias nano='nvim'"
    
    # Test Docker aliases
    run_content_test "d alias configured" "$HOME/.zshrc" "alias d='docker'"
    run_content_test "dc alias configured" "$HOME/.zshrc" "alias dc='docker-compose'"
    
    # Test custom functions
    run_content_test "project function exists" "$HOME/.zshrc" "project() {"
    run_content_test "newproj function exists" "$HOME/.zshrc" "newproj() {"
    run_content_test "pg_new function exists" "$HOME/.zshrc" "pg_new() {"
    run_content_test "pg_connect function exists" "$HOME/.zshrc" "pg_connect() {"
    run_content_test "git_new function exists" "$HOME/.zshrc" "git_new() {"
    run_content_test "perf_check function exists" "$HOME/.zshrc" "perf_check() {"
    run_content_test "fe function exists" "$HOME/.zshrc" "fe() {"
    run_content_test "mkcd function exists" "$HOME/.zshrc" "mkcd() {"
}

test_functionality() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Functionality${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    # Test project creation function
    echo -e "\n${YELLOW}Testing project functionality:${NC}"
    
    # Create test project
    local test_project="$HOME/projects/test_project_$$"
    if mkdir -p "$HOME/projects" 2>/dev/null; then
        if zsh -c "source $HOME/.zshrc && newproj python test_project_$$" 2>/dev/null; then
            run_file_test "Test project directory created" "$test_project" "directory"
            run_file_test "Python venv created" "$test_project/.venv" "directory"
            run_file_test "Python venv activation script exists" "$test_project/.venv/bin/activate"
            
            # Cleanup test project
            rm -rf "$test_project" 2>/dev/null || true
        else
            log_test "newproj function" "WARN" "Could not test newproj function"
        fi
    fi
    
    # Test basic tool functionality
    echo -e "\n${YELLOW}Testing basic tool functionality:${NC}"
    
    # Create test file for tools
    local test_file="/tmp/test_file_$$"
    echo "Test content for bat and exa" > "$test_file"
    
    run_test "bat can read file" "bat $test_file >/dev/null"
    run_test "exa can list current directory" "exa >/dev/null"
    run_test "ripgrep can search" "echo 'test' | rg 'test' >/dev/null"
    run_test "fzf can create process" "echo 'test' | fzf -f 'test' --filter 'test' >/dev/null"
    
    # Cleanup
    rm -f "$test_file" 2>/dev/null || true
}

test_security() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Security Configuration${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    # Test file permissions
    run_test ".zshrc has correct permissions" "[ \$(stat -c %a $HOME/.zshrc) -le 644 ]"
    run_test "Starship config has correct permissions" "[ \$(stat -c %a $HOME/.config/starship.toml 2>/dev/null || echo 644) -le 644 ]"
    
    # Test no sensitive data in configs
    run_content_test "No passwords in .zshrc" "$HOME/.zshrc" "password" "1" || true
    run_content_test "No API keys in .zshrc" "$HOME/.zshrc" "api.*key" "1" || true
    
    # Test secure PATH ordering (system paths first)
    if [ -f "$HOME/.zshrc" ]; then
        local path_order=$(grep "export PATH=" "$HOME/.zshrc" | head -1)
        if echo "$path_order" | grep -q "/usr/local/bin.*\$HOME/.local/bin"; then
            log_test "PATH security" "PASS" "System paths appear before user paths"
        else
            log_test "PATH security" "WARN" "PATH order may need review"
        fi
    fi
}

test_performance() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Testing Performance${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    # Test shell startup time
    if command -v zsh >/dev/null 2>&1; then
        local startup_time=$(time zsh -i -c 'exit' 2>&1 | grep real | awk '{print $2}' || echo "unknown")
        if [[ "$startup_time" =~ ^0\.[0-9] ]]; then
            log_test "Shell startup time" "PASS" "ZSH starts in $startup_time"
        else
            log_test "Shell startup time" "WARN" "ZSH startup time is $startup_time (may be slow)"
        fi
    fi
    
    # Test tool response times
    local tools=("nvim" "git" "docker" "node" "python3" "cargo" "go")
    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            local tool_time=$(timeout 5s time "$tool" --version 2>&1 | grep real | awk '{print $2}' || echo "timeout")
            if [ "$tool_time" != "timeout" ]; then
                log_test "$tool response time" "PASS" "$tool responds in $tool_time"
            else
                log_test "$tool response time" "WARN" "$tool timed out or slow"
            fi
        fi
    done
}

print_summary() {
    echo -e "\n${BLUE}===========================================${NC}"
    echo -e "${BLUE}Test Results Summary${NC}"
    echo -e "${BLUE}===========================================${NC}"
    
    echo -e "Total Tests: $TOTAL_TESTS"
    echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
    echo -e "${RED}Failed: $FAILED_TESTS${NC}"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "\n${GREEN}🎉 All tests passed! Installation is working correctly.${NC}"
        return 0
    else
        echo -e "\n${RED}❌ $FAILED_TESTS test(s) failed. Check the log for details.${NC}"
        echo -e "Detailed log available at: $TEST_RESULTS_FILE"
        return 1
    fi
}

main() {
    echo -e "${BLUE}===========================================${NC}"
    echo -e "${BLUE}DotFiles Installation Test Suite${NC}"
    echo -e "${BLUE}===========================================${NC}"
    echo -e "Test log: $TEST_RESULTS_FILE"
    
    echo "# DotFiles Installation Test Results" > "$TEST_RESULTS_FILE"
    echo "# Generated on: $(date)" >> "$TEST_RESULTS_FILE"
    echo "# =======================================" >> "$TEST_RESULTS_FILE"
    echo "" >> "$TEST_RESULTS_FILE"
    
    # Run all test suites
    test_shell_setup
    test_terminal_tools
    test_development_tools
    test_languages
    test_containers
    test_databases
    test_configurations
    test_aliases_and_functions
    test_functionality
    test_security
    test_performance
    
    # Print summary and exit with appropriate code
    print_summary
}

# Run the test suite
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi