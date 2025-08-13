
#!/usr/bin/env zsh
# ============================================================================
# Complete Zsh Configuration File
# ============================================================================
# Author: Felly
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
export PATH="$HOME/.npm-global/bin:$PATH"               # npm global packages


# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"          # Configuration files
export XDG_DATA_HOME="$HOME/.local/share"       # Data files
export XDG_CACHE_HOME="$HOME/.cache"            # Cache files
export XDG_STATE_HOME="$HOME/.local/state"      # State files

# Application-specific environment variables
# export DOCKER_HOST="unix:///var/run/docker.sock"     # Docker host
# export COMPOSE_DOCKER_CLI_BUILD=1                    # Docker Compose CLI
# export BUILDKIT_PROGRESS=plain                       # Docker Buildkit
# export FZF_DEFAULT_COMMAND="fd --type f"             # fzf default command
# export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"  # fzf options

# ============================================================================
# ZSH HISTORY CONFIGURATION
# ============================================================================

HISTFILE=~/.histfile                           # History file location
HISTSIZE=50000                                 # History size in memory
SAVEHIST=50000                                 # History size on disk
# HISTFILE="${XDG_STATE_HOME}/zsh/history"    # XDG compliant history location

# History behavior options
setopt HIST_EXPIRE_DUPS_FIRST          # Expire duplicate entries first
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

# Additional history options (commented out)
# setopt HIST_NO_STORE                 # Don't store history commands
# setopt HIST_NO_FUNCTIONS             # Don't store function definitions
# setopt HIST_BEEP                     # Beep when accessing non-existent history
# setopt BANG_HIST                     # Treat '!' specially in history expansion

# ============================================================================
# ZSH OPTIONS AND BEHAVIOR
# ============================================================================

setopt AUTO_CD                         # Just type directory name to cd
setopt AUTO_PUSHD                      # Push directories onto stack automatically
setopt PUSHD_IGNORE_DUPS              # Don't push duplicate directories
setopt PUSHD_SILENT                   # Don't print directory stack after pushd/popd
setopt CDABLE_VARS                    # Allow cd to variable names
# setopt PUSHD_TO_HOME                # pushd without args goes to home
# setopt PUSHD_MINUS                  # Exchange meaning of +/- for pushd

setopt AUTO_LIST                      # List choices on ambiguous completion
setopt AUTO_MENU                      # Use menu completion after second tab
setopt COMPLETE_IN_WORD               # Complete from both ends of word
setopt ALWAYS_TO_END                  # Move cursor to end after completion
setopt LIST_PACKED                    # Compact completion lists
setopt LIST_TYPES                     # Show file types in completion
# setopt MENU_COMPLETE                # Insert first match immediately
setopt AUTO_PARAM_SLASH             # Add slash after completing directories
# setopt AUTO_PARAM_KEYS              # Remove trailing characters if needed
# setopt AUTO_REMOVE_SLASH            # Remove trailing slash when needed
setopt COMPLETE_ALIASES             # Complete aliases
# setopt GLOB_COMPLETE                # Generate glob matches as completions
# setopt HASH_LIST_ALL                # Hash command path on first completion

setopt EXTENDED_GLOB                  # Use extended globbing syntax
setopt GLOB_DOTS                      # Include dotfiles in globbing
setopt NUMERIC_GLOB_SORT              # Sort numeric filenames numerically
# setopt NO_CASE_GLOB                 # Case insensitive globbing
# setopt NULL_GLOB                    # Delete pattern if no matches
# setopt GLOB_SUBST                   # Expand globs in parameter substitution
# setopt WARN_CREATE_GLOBAL           # Warn when creating global parameters
# setopt CSH_NULL_GLOB                # Error if no glob match (like csh)
# setopt BASH_GLOB                    # Use bash-style globbing
# setopt KSH_GLOB                     # Use ksh-style globbing

setopt AUTO_RESUME                    # Single word commands resume jobs
setopt LONG_LIST_JOBS                 # List jobs in long format
setopt NOTIFY                         # Report job status immediately
# setopt NO_BG_NICE                   # Don't run background jobs at lower priority
# setopt NO_HUP                       # Don't send HUP signal to jobs on shell exit
# setopt CHECK_JOBS                   # Check for jobs before exiting
# setopt NO_CHECK_JOBS                # Don't check for jobs before exiting

setopt CORRECT                        # Spell correction for commands
setopt CORRECT_ALL                    # Spell correction for all arguments
setopt INTERACTIVE_COMMENTS           # Allow comments in interactive shell
setopt RC_QUOTES                      # Allow '' to represent single quote in strings
setopt SHORT_LOOPS                    # Allow short forms of for/repeat/select
# setopt CLOBBER                      # Allow > redirection to overwrite files
# setopt NO_CLOBBER                   # Prevent > redirection from overwriting
# setopt APPEND_CREATE                # Create files with >> if they don't exist
# setopt MULTIOS                      # Allow multiple redirections
# setopt PATH_DIRS                    # Search path even for commands with slashes
# setopt HASH_CMDS                    # Hash commands as they are executed
# setopt HASH_DIRS                    # Hash directories as they are added to path

setopt PROMPT_SUBST                   # Allow parameter expansion in prompts
setopt TRANSIENT_RPROMPT              # Remove right prompt after command
# setopt PROMPT_CR                    # Print CR before each prompt
# setopt PROMPT_SP                    # Preserve partial line before prompt
# setopt SINGLE_LINE_ZLE              # Use single line for line editor

# setopt C_BASES                      # Use 0x prefix for hex numbers
# setopt OCTAL_ZEROES                 # Use leading zeros for octal numbers
# setopt TYPESET_SILENT               # Don't print values when setting variables
# setopt WARN_CREATE_GLOBAL           # Warn when creating global variables
# setopt LOCAL_OPTIONS                # Options set in functions are local
# setopt LOCAL_TRAPS                  # Traps set in functions are local
# setopt FUNCTION_ARGZERO             # Set $0 to function name
# setopt MULTI_FUNC_DEF               # Allow multiple function definitions

bindkey -e                           # Use Emacs key bindings
# bindkey -v                         # Use Vi key bindings

# ============================================================================
# COMPLETION SYSTEM SETUP
# ============================================================================

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select                    # Use menu for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # Use colors in completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'  # Case insensitive matching
zstyle ':completion:*' completer _expand _complete _correct _approximate  # Completion strategies
zstyle ':completion:*' format 'Completing %d'        # Completion group format
zstyle ':completion:*' group-name ''                 # Group completions
zstyle ':completion:*' verbose yes                   # Verbose completions

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'  # Description format
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'  # No match warning
# zstyle ':completion:*' use-cache on                 # Use completion cache
# zstyle ':completion:*' cache-path ~/.zcompcache     # Cache location
# zstyle ':completion:*:cd:*' ignore-parents parent pwd  # Don't complete parent dirs
# zstyle ':completion:*:*:kill:*' menu yes select     # Menu for kill command
# zstyle ':completion:*:kill:*' force-list always     # Always show kill list

# ============================================================================
# ALIASES
# ============================================================================

alias ls='ls --color=auto'            # Colorized ls
alias ll='ls -lah'                    # Long list with hidden files
alias la='ls -A'                      # List all except . and ..
alias l='ls -CF'                      # Classify files
alias grep='grep --color=auto'        # Colorized grep
alias fgrep='fgrep --color=auto'      # Colorized fgrep
alias egrep='egrep --color=auto'      # Colorized egrep

alias ..='cd ..'                      # Go up one directory
alias ...='cd ../..'                  # Go up two directories
alias ....='cd ../../..'              # Go up three directories
alias .....='cd ../../../..'          # Go up four directories
alias ~="cd ~"                      # Go to home directory
alias -- -="cd -"                  # Go to previous directory

alias gs='git status'                 # Git status
alias ga='git add'                    # Git add
alias gc='git commit'                 # Git commit
alias gp='git push'                   # Git push
alias gl='git pull'                   # Git pull
alias gd='git diff'                   # Git diff
alias gb='git branch'                 # Git branch
alias gco='git checkout'              # Git checkout
alias glog='git log --oneline --graph'  # Pretty git log
# alias gcm='git commit -m'           # Git commit with message
# alias gca='git commit -am'          # Git commit all with message
# alias gst='git stash'               # Git stash
# alias gsp='git stash pop'           # Git stash pop

alias df='df -h'                      # Human readable df
alias du='du -h'                      # Human readable du
alias free='free -h'                  # Human readable free
alias ps='ps aux'                     # Detailed process list
alias top='htop'                      # Use htop instead of top
alias tree='tree -C'                  # Colorized tree
# alias mkdir='mkdir -p'              # Create parent directories
# alias cp='cp -i'                    # Interactive copy
# alias mv='mv -i'                    # Interactive move
# alias rm='rm -i'                    # Interactive remove
# alias ln='ln -i'                    # Interactive link

alias vim='nvim'                      # Use neovim
alias vi='nvim'                       # Use neovim
alias nano='nvim'                     # Use neovim as nano

# --- Network Aliases ---
# alias myip='curl -s https://ipinfo.io/ip'  # Get public IP
# alias localip='ip route get 1.2.3.4 | awk "{print $7}"'  # Get local IP
# alias ports='netstat -tulanp'       # Show open ports

# --- Docker Aliases ---
# alias d='docker'                    # Docker shorthand
# alias dc='docker-compose'           # Docker compose shorthand
# alias dps='docker ps'               # Docker process status
# alias di='docker images'            # Docker images
# alias dex='docker exec -it'         # Docker exec interactive

# ============================================================================
# FUNCTIONS
# ============================================================================

git_prompt_info() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    local dirty=$(git status --porcelain 2>/dev/null)
    if [[ -n $dirty ]]; then
      echo "%F{0} ${branch} %F{196}✗%f"
    else
      echo "%F{0} ${branch}%f"
    fi
  fi
}

last_cmd_duration() {
  if [[ -n $CMD_DURATION && $CMD_DURATION -gt 50 ]]; then
    local ms=$CMD_DURATION
    local sec=$(( ms / 1000 ))
    local rem_ms=$(( ms % 1000 ))
    local emoji

    if (( sec > 60 )); then emoji="⏳"
    elif (( sec > 10 )); then emoji="⌛"
    elif (( sec > 3 )); then emoji="🕒"
    else emoji="⚡"; fi

    if (( sec > 59 )); then
      local min=$(( sec / 60 ))
      sec=$(( sec % 60 ))
      printf "%s %dm%02ds" $emoji $min $sec
    elif (( sec > 0 )); then
      printf "%s %d.%03ds" $emoji $sec $rem_ms
    else
      printf "%s %dms" $emoji $ms
    fi
  fi
}

last_cmd_status() {
  local code=$?
  if (( code == 0 )); then
    echo "%F{0}✔%f"
  else
    echo "%F{0}✘ $code%f"
  fi
}

greeting() {
  local hour=$(date +%H)
  if (( hour < 5 )); then echo "🌙"
  elif (( hour < 12 )); then echo "🌅"
  elif (( hour < 18 )); then echo "☀️"
  else echo "🌆"; fi
}

autoload -Uz add-zsh-hook
preexec() { CMD_START_TIME=$(date +%s%3N) }
precmd() {
  if [[ -n $CMD_START_TIME ]]; then
    local now=$(date +%s%3N)
    CMD_DURATION=$(( now - CMD_START_TIME ))
  else
    CMD_DURATION=0
  fi
  unset CMD_START_TIME
}
add-zsh-hook preexec preexec
add-zsh-hook precmd precmd

# ============================================================================
# POWERLINE WITH OVERLAPPING ARROW AND DYNAMIC DISTRO ICON
# ============================================================================

build_prompt() {
  local segments=()
  segments+=("%n@%m")
  segments+=("%~")
  local ginfo=$(git_prompt_info)
  [[ -n $ginfo ]] && segments+=("$ginfo")
  local dur=$(last_cmd_duration)
  [[ -n $dur ]] && segments+=("$dur")
  local stat=$(last_cmd_status)
  [[ -n $stat ]] && segments+=("$stat")

  local colors=(196 202 220 118 39 93 201)
  local prompt=""
  local seg_count=${#segments[@]}

  for ((i=0; i<seg_count; i++)); do
    local bg=${colors[i % ${#colors[@]}]}
    local next_bg=""
    if (( i < seg_count - 1 )); then
      next_bg=${colors[(i+1) % ${#colors[@]}]}
    fi

    prompt+="%K{$bg}%F{0} ${segments[i]} %k%f"

    if [[ -n $next_bg ]]; then
      prompt+="%F{$bg}%K{$next_bg}%k%f"
    fi
  done

  echo "$prompt"
}


setopt PROMPT_SUBST

PROMPT='$(build_prompt)'
PROMPT+=$'\n''%F{39}❯%f '

RPROMPT='%F{255}$(greeting) %D{%H:%M:%S}%f'


# --- Utility Functions (commented out examples) ---
# # Extract various archive formats
# extract() {
#   if [ -f $1 ] ; then
#     case $1 in
#       *.tar.bz2)   tar xjf $1     ;;
#       *.tar.gz)    tar xzf $1     ;;
#       *.bz2)       bunzip2 $1     ;;
#       *.rar)       unrar e $1     ;;
#       *.gz)        gunzip $1      ;;
#       *.tar)       tar xf $1      ;;
#       *.tbz2)      tar xjf $1     ;;
#       *.tgz)       tar xzf $1     ;;
#       *.zip)       unzip $1       ;;
#       *.Z)         uncompress $1  ;;
#       *.7z)        7z x $1        ;;
#       *)     echo "'$1' cannot be extracted via extract()" ;;
#     esac
#   else
#     echo "'$1' is not a valid file"
#   fi
# }

# # Make directory and cd into it
# mkcd() {
#   mkdir -p "$1" && cd "$1"
# }

# # Find process by name
# psg() {
#   ps aux | grep -v grep | grep "$@" -i --color=always
# }

# Weather function
weather() {
  curl -s "wttr.in/$1"
}

# ============================================================================
# ZINIT PLUGIN MANAGER SETUP
# ============================================================================

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

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions      # Fish-like autosuggestions

zinit ice wait"0"
zinit light zsh-users/zsh-syntax-highlighting  # Syntax highlighting

zinit light zsh-users/zsh-history-substring-search  # History search with arrows
zinit light zsh-users/zsh-completions         # Additional completions
zinit light rupa/z                            # Jump to directories (z command)
zinit light tarrasch/zsh-autoenv              # Auto source .env files
zinit light mafredri/zsh-async                # Async functions

# --- Additional Useful Plugins (commented out) ---
zinit light zdharma-continuum/fast-syntax-highlighting  # Faster syntax highlighting
zinit light marlonrichert/zsh-autocomplete   # Better autocomplete
zinit light Aloxaf/fzf-tab                   # fzf integration for completions
# zinit light agkozak/zsh-z                    # Alternative to rupa/z
zinit light hlissner/zsh-autopair            # Auto-pair brackets/quotes
zinit light MichaelAquilina/zsh-you-should-use  # Suggest aliases for commands
zinit light wfxr/forgit                      # Interactive git commands
# zinit light jimhester/per-directory-history  # Per-directory command history
# zinit light zsh-users/zsh-apple-touchbar     # macOS Touch Bar support

# --- Themes (commented out - using custom prompt) ---
# zinit ice depth=1; zinit light romkatv/powerlevel10k    # Powerlevel10k theme
# zinit light spaceship-prompt/spaceship-prompt          # Spaceship theme
# zinit light sindresorhus/pure                          # Pure theme

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ============================================================================
# ADDITIONAL TOOL CONFIGURATIONS
# ============================================================================

if command -v fzf &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# --- Python Virtual Environment ---
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"

# ============================================================================
# KEY BINDINGS
# ============================================================================

# History substring search bindings
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow
bindkey -M emacs '^P' history-substring-search-up    # Ctrl-P
bindkey -M emacs '^N' history-substring-search-down  # Ctrl-N

# Additional useful key bindings (commented out)
# bindkey '^R' history-incremental-search-backward  # Ctrl-R for reverse search
# bindkey '^S' history-incremental-search-forward   # Ctrl-S for forward search
bindkey '^[[1;5C' forward-word                    # Ctrl-Right arrow
bindkey '^[[1;5D' backward-word                   # Ctrl-Left arrow
# bindkey '^[[3~' delete-char                       # Delete key
# bindkey '^[[H' beginning-of-line                  # Home key
# bindkey '^[[F' end-of-line                        # End key

# ============================================================================
# DEVICE-SPECIFIC CONFIGURATION
# ============================================================================

# Load device-specific configuration if it exists
# This file should contain device-specific settings like:
# - Different paths
# - Device-specific aliases
# - Custom environment variables
# - Local development settings
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================================
# PERFORMANCE MONITORING (for debugging)
# ============================================================================

# Uncomment to enable zsh startup time profiling
# zmodload zsh/zprof

# Add this line at the end of the file to see profiling results:
# zprof
