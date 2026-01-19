#!/usr/bin/env zsh

export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.npm-global/bin:$PATH"

export BAT_THEME="GitHub"
export DELTA_PAGER="less -R"
export EXA_ICON_SPACING=2
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# PostgreSQL Configuration (customize as needed)
# export PGDATA="/var/lib/postgresql/16/main"
# export PGHOST="localhost"
# export PGPORT="5432"
# export PGUSER="$USER"
# export PGDATABASE="$USER"

alias cat='bat --style=numbers,changes,header --file-name --theme=GitHub'
alias ls='exa --long --header --git --icons --group-directories-first'
alias ll='exa --long --header --git --icons --all --group-directories-first'
alias la='exa --long --header --git --icons --all --binary --group-directories-first'
alias lt='exa --tree --level=3 --icons --git'
alias tree='exa --tree --icons --git'
alias diff='delta'
alias top='btop'
alias htop='btop'
alias find='fd'
alias grep='rg'

alias py='python3'
alias pip='pip3'
alias pyrun='python3 -m'
alias pytest='python3 -m pytest'
alias python-shell='python3 -i'
alias nv='nvim'
alias vim='nvim'
alias vi='nvim'
alias nano='nvim'
alias serve='python3 -m http.server 8000'

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias glog='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gsp='git stash pop'
alias gclean='git clean -fd'
alias greset='git reset --hard'
alias gamend='git commit --amend --no-edit'
alias gcredit='git commit --amend --author='
alias gsl='git shortlog -sn'
alias gundo='git reset --soft HEAD~1'
alias grename='git branch -m'
alias garchive='git archive master --format=zip --output=archive.zip'

alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias di='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.Created}}"'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias drmi='docker images -f "dangling=true" -q | xargs docker rmi'
alias dclean='docker system prune -f'

dstop() {
  local containers
  containers=$(docker ps -q)
  if [[ -n "$containers" ]]; then
    docker stop $containers
  else
    echo "No running containers to stop."
  fi
}

dnuke() {
  local containers
  containers=$(docker ps -q)
  if [[ -n "$containers" ]]; then
    docker stop $containers
  fi
  docker system prune -af
}

# PostgreSQL aliases (customize version and user as needed)
alias pg-start='sudo systemctl start postgresql'
alias pg-stop='sudo systemctl stop postgresql'
alias pg-restart='sudo systemctl restart postgresql'
alias pg-status='sudo systemctl status postgresql'
# alias psql='psql -h localhost -U $USER'
alias pg-list='psql -l'
alias pg-create='createdb'
alias pg-drop='dropdb'
alias pg-dump='pg_dump'
alias pg-restore='psql'
alias pg-shell='sudo -u postgres psql'

# Project aliases (customize paths as needed)
alias pj='cd ~/projects'
# alias pbackup='~/scripts/backup_projects.sh'
# alias dev='~/scripts/dev_env.sh'
alias pp='cd $(find ~/projects -maxdepth 1 -type d 2>/dev/null | fzf)'

alias md='mkdir -p'
alias rd='rmdir'
alias copy='cp -r'
alias move='mv'
alias del='rm -rf'
alias size='du -sh'
alias space='df -h'
alias ports='netstat -tuln'
alias untar='tar -xzf'
alias zip='gzip'
alias unzip='gunzip'

alias myip='curl -s https://ipinfo.io/ip'
alias localip='hostname -I | awk "{print \$1}"'
alias ping='ping -c 4'
alias speed='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3'
alias check-ssl='openssl s_client -connect'
alias http-serve='python3 -m http.server 8000'
alias file-serve='ruby -run -e httpd . -p 9090'

alias perf='perf_check'
alias mem='free -h'
alias disk='df -h'
alias load='uptime'
alias temp='sensors 2>/dev/null || echo "No sensors available"'
alias connections='ss -tuln'
alias processes='ps aux --sort=-%cpu | head -20'
alias memory-hogs='ps aux --sort=-%mem | head -10'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~="cd ~"
alias -- -="cd -"

# Custom mount aliases (customize for your setup)
# alias mount_usb='sudo mount UUID=<YOUR_UUID> ~/external'
# alias unmount_usb="sudo umount ~/external"
# alias mount_server='sshfs user@server:/ ~/server -p <port>'
# alias umount_server='fusermount -u ~/server'

# Key Bindings (load after zsh-syntax-highlighting)
autoload -Uz compinit
compinit

bindkey '^R' history-incremental-search-backward  # Ctrl+R: Search history
bindkey '^[[1;5C' forward-word                    # Ctrl+Right: Jump forward word
bindkey '^[[1;5D' backward-word                   # Ctrl+Left: Jump backward word
bindkey '^[[H' beginning-of-line                  # Home: Go to start of line
bindkey '^[[F' end-of-line                        # End: Go to end of line

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Zinit Plugins - Maximum QOL
zinit light zdharma-continuum/fast-syntax-highlighting  # Syntax highlighting
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions               # Fish-like suggestions
zinit light marlonrichert/zsh-autocomplete              # Smart autocomplete
zinit light hlissner/zsh-autopair                       # Auto-pair brackets/quotes
zinit light MichaelAquilina/zsh-you-should-use          # Suggest aliases
zinit light djui/alias-tips                             # Alias reminders
zinit light wfxr/forgit                                # Interactive git
zinit light unixorn/git-extra-commands                  # Extra git commands
zinit light wfxr/formarks                              # Directory bookmarks
zinit light zsh-users/zsh-history-substring-search      # History search
zinit light rupa/z                                     # Directory jumper
zinit light tarrasch/zsh-autoenv                       # Auto .env loading
zinit light jimhester/per-directory-history             # Per-dir history
zinit light chisui/zsh-nix-shell                       # Nix shell support
zinit light zsh-users/zsh-completions                   # Completions library

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light github/gh-cli                               # GitHub CLI integration

# Starship Prompt
eval "$(starship init zsh)"

project() {
  local projects_dir="${PROJECTS_DIR:-$HOME/projects}"
  local project_dir="$projects_dir/$1"
  
  if [ -d "$project_dir" ]; then
    cd "$project_dir"
    
    if [ -f "pyproject.toml" ]; then
      poetry shell 2>/dev/null || echo "⚠️  Poetry not available"
      echo "🐍 Poetry environment activated"
    elif [ -f "venv/bin/activate" ]; then
      source venv/bin/activate
      echo "🐍 Virtual environment activated"
    elif [ -f ".venv/bin/activate" ]; then
      source .venv/bin/activate
      echo "🐍 Virtual environment activated"
    elif [ -f "package.json" ]; then
      echo "📦 Node.js project detected"
    elif [ -f "Cargo.toml" ]; then
      echo "🦀 Rust project detected"
    elif [ -f "docker-compose.yml" ] || [ -f "Dockerfile" ]; then
      echo "🐳 Docker project detected"
    fi
    
    echo "📁 Project: $1"
    echo "🌿 $(git branch --show-current 2>/dev/null || echo 'No git')"
    echo "📋 $(ls -1 2>/dev/null | wc -l) files/folders"
  else
    echo "❌ Project '$1' not found in $projects_dir/"
    if [ -d "$projects_dir" ]; then
      echo "Available projects:"
      ls "$projects_dir"
    else
      echo "Projects directory not found: $projects_dir"
    fi
  fi
}

alias proj='project'

newproj() {
  local project_type="$1"
  local project_name="$2"
  local projects_dir="${PROJECTS_DIR:-$HOME/projects}"
  local project_dir="$projects_dir/$project_name"
  
  if [ -z "$project_name" ]; then
    echo "Usage: newproj {python|node|rust|docker|generic|fastapi|react|springboot|rustapi} project_name"
    return 1
  fi
  
  mkdir -p "$project_dir"
  cd "$project_dir"
  
  case "$project_type" in
    "springboot")
      mkdir -p src/main/java/com/example src/main/resources
      cat > pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>
    <groupId>com.example</groupId>
    <artifactId>PROJECT_NAME</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>PROJECT_NAME</name>
    <properties>
        <java.version>17</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOF
      
      cat > src/main/java/com/example/Application.java << 'EOF'
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
EOF
      
      mkdir -p src/main/java/com/example/controller
      cat > src/main/java/com/example/controller/HelloController.java << 'EOF'
package com.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @GetMapping("/")
    public String index() {
        return "Hello from Spring Boot!";
    }
    
    @GetMapping("/api/hello")
    public String hello() {
        return "Hello API from Spring Boot!";
    }
}
EOF
      
      cat > src/main/resources/application.properties << 'EOF'
spring.application.name=PROJECT_NAME
server.port=8080

spring.datasource.url=jdbc:postgresql://localhost:5432/YOUR_DATABASE
spring.datasource.username=YOUR_USERNAME
spring.datasource.password=YOUR_PASSWORD
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
EOF
      
      sed -i "s/PROJECT_NAME/$project_name/g" pom.xml src/main/resources/application.properties
      echo "🌱 Spring Boot project created: $project_name"
      ;;
    "react")
      npx create-react-app . --template typescript
      echo "⚛️ React TypeScript project created: $project_name"
      ;;
    "rustapi")
      cat > Cargo.toml << 'EOF'
[package]
name = "PROJECT_NAME"
version = "0.1.0"
edition = "2021"

[dependencies]
tokio = { version = "1.0", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
sqlx = { version = "0.7", features = ["runtime-tokio-rustls", "postgres"] }
axum = "0.7"
EOF
      
      mkdir -p src
      cat > src/main.rs << 'EOF'
use axum::{extract::Path, response::Json, routing::get, Router};
use serde::Deserialize;
use std::net::SocketAddr;

#[derive(Deserialize)]
struct HelloRequest {
    name: String,
}

#[derive(serde::Serialize)]
struct HelloResponse {
    message: String,
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(root))
        .route("/api/hello/:name", get(hello_name));

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    println!("Listening on {}", addr);
    axum::serve(listener, app).await.unwrap();
}

async fn root() -> &'static str {
    "Hello from Rust API!"
}

async fn hello_name(Path(name): Path<String>) -> Json<HelloResponse> {
    Json(HelloResponse {
        message: format!("Hello, {}!", name),
    })
}
EOF
      
      sed -i "s/PROJECT_NAME/$project_name/g" Cargo.toml
      echo "🦀 Rust API project created: $project_name"
      ;;
    "python")
      python3 -m venv .venv
      source .venv/bin/activate
      pip install --upgrade pip black pytest flake8
      cat > README.md << EOF
# $project_name

## Development
\`\`\`bash
source .venv/bin/activate
pip install -r requirements.txt
\`\`\`
EOF
      echo "🐍 Python project created: $project_name"
      ;;
    "node")
      npm init -y
      npm install --save-dev prettier eslint
      cat > README.md << EOF
# $project_name

## Development
\`\`\`bash
npm install
npm start
\`\`\`
EOF
      echo "📦 Node.js project created: $project_name"
      ;;
    "rust")
      cargo init --name "$project_name"
      echo "🦀 Rust project created: $project_name"
      ;;
    "docker")
      cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]
EOF
      cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - .:/app
    environment:
      - FLASK_ENV=development
EOF
      cat > app.py << 'EOF'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF
      echo "🐳 Docker project created: $project_name"
      ;;
    "generic")
      cat > README.md << EOF
# $project_name

## Description
Your project description here.

## Setup
Your setup instructions here.
EOF
      echo "📁 Generic project created: $project_name"
      ;;
  esac
  
  git init
  git add .
  git commit -m "Initial commit"
}

pg_new() {
  local db_name="$1"
  if [ -z "$db_name" ]; then
    echo "Usage: pg_new database_name"
    return 1
  fi
  createdb "$db_name"
  echo "✅ Created database: $db_name"
  echo "🔗 Connect with: psql $db_name"
}

pg_connect() {
  local db_name="$1"
  if [ -z "$db_name" ]; then
    echo "Usage: pg_connect database_name"
    echo "Available databases:"
    psql -l | grep -v "^List" | grep -v "^(" | grep -v "^---" | awk '{print $1}'
    return 1
  fi
  psql "$db_name"
}

pg_backup() {
  local db_name="$1"
  local backup_file="$2"
  if [ -z "$db_name" ]; then
    echo "Usage: pg_backup database_name [backup_file]"
    return 1
  fi
  if [ -z "$backup_file" ]; then
    backup_file="${db_name}_$(date +%Y%m%d_%H%M%S).sql"
  fi
  pg_dump "$db_name" > "$backup_file"
  echo "✅ Backed up $db_name to $backup_file"
}

dev_docker() {
  local action="$1"
  shift
  case "$action" in
    "up")
      docker-compose up -d "$@"
      echo "🐳 Containers started"
      ;;
    "down")
      docker-compose down "$@"
      echo "🐳 Containers stopped"
      ;;
    "logs")
      docker-compose logs -f "$@"
      ;;
    "build")
      docker-compose build "$@"
      echo "🐳 Images built"
      ;;
    "shell")
      local service="$1"
      if [ -z "$service" ]; then
        echo "Available services:"
        docker-compose config --services
        return 1
      fi
      docker-compose exec "$service" sh
      ;;
    "ps")
      docker-compose ps "$@"
      ;;
    "restart")
      docker-compose restart "$@"
      ;;
    *)
      echo "Usage: dev_docker {up|down|logs|build|shell|ps|restart} [service]"
      ;;
  esac
}

git_new() {
  local repo_name="$1"
  local visibility="${2:-public}"
  local description="${3:-}"
  
  if [ -z "$repo_name" ]; then
    echo "Usage: git_new repo_name [public|private] [description]"
    return 1
  fi
  
  local projects_dir="${PROJECTS_DIR:-$HOME/projects}"
  mkdir -p "$projects_dir/$repo_name"
  cd "$projects_dir/$repo_name"
  git init
  
  if [ -n "$description" ]; then
    echo "# $repo_name" > README.md
    echo "" >> README.md
    echo "$description" >> README.md
  else
    echo "# $repo_name" > README.md
  fi
  
  git add README.md
  git commit -m "Initial commit"
  
  if command -v gh &> /dev/null; then
    echo "Creating GitHub repository: $repo_name ($visibility)"
    gh repo create "$repo_name" --"$visibility" --source=. --push --description="$description"
    echo "✅ Repository created and pushed: $repo_name"
  else
    echo "⚠️  GitHub CLI not found. Install gh to create remote repositories."
    echo "Repository created locally. Run 'gh repo create $repo_name' after installing gh."
  fi
}

perf_check() {
  echo "🖥️  Performance Check - $(date)"
  echo "================================"
  
  echo "📊 System Info:"
  echo "  OS: $(uname -s) $(uname -r)"
  echo "  Uptime: $(uptime -p)"
  echo "  Load: $(uptime | grep -o "load average:.*" | cut -d: -f2)"
  
  echo ""
  echo "💾 Memory Usage:"
  free -h | grep "Mem:" | awk '{print "  Used: " $3 "/" $2 " (" int($3/$2*100) "%)"}'
  echo "  Swap: $(free -h | grep "Swap:" | awk '{print $3 "/" $2}')"
  
  echo ""
  echo "💽 Disk Usage:"
  df -h | grep -E "(Filesystem|/dev/)" | while read line; do
    if [[ $line == Filesystem* ]]; then
      echo "  $line"
    else
      echo "  $(echo $line | awk '{print $6 ": " $3 "/" $2 " (" $5 ")"}')"
    fi
  done
  
  echo ""
  echo "🔥 Top CPU Processes:"
  ps aux --sort=-%cpu | head -6 | while read line; do
    if [[ $line == USER* ]]; then
      echo "  $line"
    else
      local pid=$(echo $line | awk '{print $2}')
      local cpu=$(echo $line | awk '{print $3}')
      local mem=$(echo $line | awk '{print $4}')
      local cmd=$(echo $line | awk '{for(i=11;i<=NF;i++) printf $i " "; print ""}')
      echo "  PID:$pid CPU:$cpu% MEM:$mem% $cmd"
    fi
  done
  
  echo ""
  echo "💾 Top Memory Processes:"
  ps aux --sort=-%mem | head -6 | while read line; do
    if [[ $line == USER* ]]; then
      echo "  $line"
    else
      local pid=$(echo $line | awk '{print $2}')
      local cpu=$(echo $line | awk '{print $3}')
      local mem=$(echo $line | awk '{print $4}')
      local cmd=$(echo $line | awk '{for(i=11;i<=NF;i++) printf $i " "; print ""}')
      echo "  PID:$pid CPU:$cpu% MEM:$mem% $cmd"
    fi
  done
}

port_check() {
  local port="$1"
  if [ -z "$port" ]; then
    echo "Usage: port_check port_number"
    return 1
  fi
  
  echo "🔍 Checking port $port..."
  local process=$(lsof -i :"$port" 2>/dev/null)
  if [ -n "$process" ]; then
    echo "🔴 Port $port is IN USE:"
    echo "$process"
  else
    echo "🟢 Port $port is FREE"
  fi
}

port_kill() {
  local port="$1"
  local pid=$(lsof -ti :"$port" 2>/dev/null)
  if [ -n "$pid" ]; then
    # Try graceful termination first
    if kill "$pid" 2>/dev/null; then
      echo "🔪 Sent SIGTERM to process on port $port (PID: $pid)"
      sleep 2
      # Check if process is still running
      if kill -0 "$pid" 2>/dev/null; then
        echo "⚠️ Process still running, sending SIGKILL..."
        kill -9 "$pid"
        echo "🔪 Killed process on port $port (PID: $pid)"
      else
        echo "✅ Process terminated gracefully"
      fi
    else
      # If SIGTERM fails, use SIGKILL
      kill -9 "$pid"
      echo "🔪 Killed process on port $port (PID: $pid)"
    fi
  else
    echo "⚠️ No process found on port $port"
  fi
}

port_scan() {
  echo "🔍 Scanning common ports..."
  local ports=(22 80 443 3000 5000 5432 6379 8080 8000 9000 27017)
  
  for port in "${ports[@]}"; do
    local status=$(lsof -i :"$port" 2>/dev/null)
    if [ -n "$status" ]; then
      echo "🔴 Port $port: IN USE"
    else
      echo "🟢 Port $port: Free"
    fi
  done
}

backup_projects() {
  # Customize backup directory as needed
  local backup_dir="${BACKUP_DIR:-$HOME/backups/projects}"
  local timestamp=$(date +%Y%m%d_%H%M%S)
  local backup_file="projects_backup_${timestamp}.tar.gz"
  
  echo "🔄 Starting backup of ~/projects..."
  mkdir -p "$backup_dir"
  
  if [ -d "$HOME/projects" ]; then
    tar -czf "$backup_dir/$backup_file" -C "$HOME" projects/
    
    local backup_size=$(du -sh "$backup_dir/$backup_file" 2>/dev/null | cut -f1)
    
    echo "✅ Backup completed: $backup_file (${backup_size:-unknown})"
    echo "📍 Location: $backup_dir/$backup_file"
    
    cd "$backup_dir" 2>/dev/null || true
    local old_backups
    old_backups=$(ls -t projects_backup_*.tar.gz 2>/dev/null | tail -n +6)
    if [ -n "$old_backups" ]; then
      echo "$old_backups" | xargs rm --
    fi
    echo "🧹 Cleaned old backups (kept last 5)"
  else
    echo "⚠️  ~/projects directory not found"
  fi
}

fe() {
  local file=$(fzf --query="$1" --select-1 --exit-0 --preview 'bat --color=always --style=numbers,header --line-range=:500 {}')
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

fe_widget() {
  fe
  zle reset-prompt
}

cd_history() {
  local dir=$(dirs -lp | fzf --query="$1" --select-1 --exit-0 --preview='exa --tree --level=2 {}')
  [ -n "$dir" ] && cd "$dir"
}

cd_history_widget() {
  cd_history
  zle reset-prompt
}

search_edit() {
  local query="$1"
  if [ -z "$query" ]; then
    echo "Usage: search_edit search_term"
    return 1
  fi
  
  local file=$(rg --files-with-matches "$query" | fzf --preview="rg --color=always --context=3 '$query' {}")
  [ -n "$file" ] && ${EDITOR:-nvim} "+/$query" "$file"
}

extract_smart() {
  local file="$1"
  if [ -f "$file" ]; then
    case "$file" in
      *.tar.bz2)   tar xjf "$file" ;;
      *.tar.gz)    tar xzf "$file" ;;
      *.bz2)       bunzip2 "$file" ;;
      *.tar)       tar xf "$file" ;;
      *.tbz2)      tar xjf "$file" ;;
      *.tgz)       tar xzf "$file" ;;
      *.zip)       unzip "$file" ;;
      *.Z)         uncompress "$file" ;;
      *.7z)        7z x "$file" ;;
      *.rar)       unrar x "$file" ;;
      *)           echo "'$file' cannot be extracted via extract_smart()" ;;
    esac
  else
    echo "'$file' is not a valid file"
  fi
}

mkcd() {
  local dir="$1"
  if [ -z "$dir" ]; then
    echo "Usage: mkcd directory_name"
    return 1
  fi
  mkdir -p "$dir" && cd "$dir"
}

watch_run() {
  local cmd="$1"
  local patterns="${2:-*.py,*.js,*.ts,*.css,*.html}"
  
  if [ -z "$cmd" ]; then
    echo "Usage: watch_run command [patterns]"
    return 1
  fi
  
  echo "👀 Watching for changes (patterns: $patterns)"
  echo "🚀 Running: $cmd"
  
  # Convert comma-separated glob patterns (e.g., "*.py,*.js") into bare
  # extensions for watchexec (e.g., --extensions py --extensions js).
  local raw_patterns="$patterns"
  local exts=()

  # Split on commas into an array
  IFS=',' read -A exts <<< "$raw_patterns"

  local watchexec_args=()
  local ext
  for ext in "${exts[@]}"; do
    # Trim surrounding whitespace
    ext="${ext#"${ext%%[![:space:]]*}"}"
    ext="${ext%"${ext##*[![:space:]]}"}"
    [ -z "$ext" ] && continue

    # Strip leading "*." or any path components, leaving just the extension
    ext="${ext##*.}"
    [ -z "$ext" ] && continue

    watchexec_args+=(--extensions "$ext")
  done

  watchexec "${watchexec_args[@]}" --restart -- "$cmd"
}

psg() {
  ps aux | grep -v grep | grep "$@" -i --color=always
}

weather() {
  curl -s "wttr.in/$1"
}

# Custom widget bindings (define widgets after functions are defined)
zle -N fe_widget
zle -N cd_history_widget
bindkey '^P' fe_widget                            # Ctrl+P: Fuzzy edit file
bindkey '^O' cd_history_widget                    # Ctrl+O: Fuzzy cd from history