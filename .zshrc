
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' format 'Currently completing %d'
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''

zstyle ':completion:*' menu select=0
zstyle ':completion:*' original false
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/felly/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall




# =====================
# Zsh configuration file
# =====================

# --- History and options ---
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory          # Append, don’t overwrite history
setopt histignoredups         # Ignore duplicates
setopt sharehistory           # Share history across terminals
setopt incappendhistory       # Save commands as you type
setopt autocd                 # Just type folder name to cd
setopt correct                # Spell correction for commands
bindkey -e                   # Emacs keybindings

# --- Aliases ---
alias ll='ls -lah'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias ..='cd ..'
alias ...='cd ../..'

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
    echo "%F{blue}%f%F{white}%B $branch %b%f%K{black}%f${bgcolor} $symbol %k"
  else
    echo ""
  fi
}

# --- Measure last command duration ---
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

# --- Format last command duration nicely ---
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

# --- Prompt setup with colors and info ---
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




### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# --- Zinit Plugin Manager Setup ---
# Source zinit for managing plugins.
# Adjust path if your install location is different.
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# --- Zinit Plugin Manager Setup ---
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# --- Use SSH URLs for all plugins ---
zinit ice from"gh"

# Productivity & quality-of-life plugins
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0"
zinit light zsh-users/zsh-syntax-highlighting

zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-completions
zinit light rupa/z
zinit light tarrasch/zsh-autoenv
zinit light mafredri/zsh-async

# --- Completion system ---
autoload -Uz compinit
compinit

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# --- Add dev tools paths (adjust if needed) ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

