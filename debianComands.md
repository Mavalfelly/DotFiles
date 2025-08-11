# Debian-Based Commands Reference

## Package Management (APT)

### apt
Main package management command for Debian/Ubuntu systems
- `apt update` - Update package index
- `apt upgrade` - Upgrade all installed packages
- `apt install <package>` - Install a package
- `apt remove <package>` - Remove a package
- `apt purge <package>` - Remove package and config files
- `apt search <term>` - Search for packages
- `apt show <package>` - Show package information
- `apt list --installed` - List installed packages
- `apt autoremove` - Remove unnecessary packages
- `apt autoclean` - Clean package cache

### apt-get
Legacy APT command (still widely used)
- `apt-get update` - Update package lists
- `apt-get upgrade` - Upgrade packages
- `apt-get dist-upgrade` - Smart upgrade with dependency handling
- `apt-get install <package>` - Install package
- `apt-get remove <package>` - Remove package
- `apt-get purge <package>` - Remove package and configs
- `apt-get autoremove` - Remove orphaned packages
- `apt-get clean` - Clean downloaded package files
- `apt-get build-dep <package>` - Install build dependencies

### apt-cache
Query APT package cache
- `apt-cache search <term>` - Search package descriptions
- `apt-cache show <package>` - Show package details
- `apt-cache depends <package>` - Show dependencies
- `apt-cache rdepends <package>` - Show reverse dependencies
- `apt-cache policy <package>` - Show package policy/versions

### dpkg
Low-level package manager
- `dpkg -i <package.deb>` - Install .deb package
- `dpkg -r <package>` - Remove package
- `dpkg -P <package>` - Purge package
- `dpkg -l` - List installed packages
- `dpkg -L <package>` - List files in package
- `dpkg -S <file>` - Find package containing file
- `dpkg --configure -a` - Configure unconfigured packages
- `dpkg --get-selections` - Show package selections

## System Information

### uname
System information
- `uname -a` - All system information
- `uname -r` - Kernel release
- `uname -m` - Machine architecture
- `uname -n` - Network node hostname
- `uname -s` - Kernel name

### lsb_release
Linux Standard Base information
- `lsb_release -a` - All LSB information
- `lsb_release -d` - Distribution description
- `lsb_release -r` - Release number
- `lsb_release -c` - Codename

### hostnamectl
Control system hostname (systemd)
- `hostnamectl` - Show hostname info
- `hostnamectl set-hostname <name>` - Set hostname
- `hostnamectl status` - Show detailed status

## File System Operations

### ls
List directory contents
- `ls -la` - Long format with hidden files
- `ls -lh` - Human readable sizes
- `ls -lt` - Sort by modification time
- `ls -lS` - Sort by size
- `ls -R` - Recursive listing

### cp
Copy files and directories
- `cp -r <src> <dest>` - Recursive copy
- `cp -p <src> <dest>` - Preserve permissions/timestamps
- `cp -u <src> <dest>` - Copy only newer files
- `cp -v <src> <dest>` - Verbose output

### mv
Move/rename files and directories
- `mv <old> <new>` - Rename/move file
- `mv -i <src> <dest>` - Interactive mode
- `mv -v <src> <dest>` - Verbose output

### rm
Remove files and directories
- `rm -rf <dir>` - Force recursive removal
- `rm -i <file>` - Interactive removal
- `rm -v <file>` - Verbose output

### find
Search for files and directories
- `find <path> -name "<pattern>"` - Find by name
- `find <path> -type f` - Find files only
- `find <path> -type d` - Find directories only
- `find <path> -size +10M` - Find files larger than 10MB
- `find <path> -mtime -7` - Find files modified in last 7 days
- `find <path> -exec <cmd> {} \;` - Execute command on results

### locate
Quick file location using database
- `locate <filename>` - Find file locations
- `updatedb` - Update locate database

### du
Disk usage information
- `du -sh <path>` - Summary with human readable sizes
- `du -ah <path>` - All files with human readable sizes
- `du -d 1` - Limit depth to 1 level

### df
Filesystem disk usage
- `df -h` - Human readable format
- `df -T` - Show filesystem types
- `df -i` - Show inode information

## File Content Operations

### cat
Display file contents
- `cat <file>` - Display entire file
- `cat -n <file>` - Display with line numbers
- `cat -A <file>` - Show all characters including non-printing

### less/more
Page through file contents
- `less <file>` - Advanced pager with search
- `more <file>` - Simple pager

### head
Display first lines of file
- `head -n 20 <file>` - Show first 20 lines
- `head -c 100 <file>` - Show first 100 characters

### tail
Display last lines of file
- `tail -n 20 <file>` - Show last 20 lines
- `tail -f <file>` - Follow file changes (useful for logs)
- `tail -F <file>` - Follow file with retry

### grep
Search text patterns
- `grep "<pattern>" <file>` - Search for pattern
- `grep -r "<pattern>" <dir>` - Recursive search
- `grep -i "<pattern>" <file>` - Case insensitive
- `grep -v "<pattern>" <file>` - Invert match
- `grep -n "<pattern>" <file>` - Show line numbers
- `grep -c "<pattern>" <file>` - Count matches

### sed
Stream editor for text manipulation
- `sed 's/old/new/g' <file>` - Replace all occurrences
- `sed -i 's/old/new/g' <file>` - Edit file in place
- `sed -n '10,20p' <file>` - Print lines 10-20

### awk
Text processing tool
- `awk '{print $1}' <file>` - Print first column
- `awk -F: '{print $1}' <file>` - Use colon as delimiter
- `awk 'NR==5' <file>` - Print 5th line

## File Permissions

### chmod
Change file permissions
- `chmod 755 <file>` - rwxr-xr-x permissions
- `chmod +x <file>` - Add execute permission
- `chmod -w <file>` - Remove write permission
- `chmod u+x <file>` - Add execute for user only

### chown
Change file ownership
- `chown user:group <file>` - Change user and group
- `chown -R user:group <dir>` - Recursive change
- `chown user <file>` - Change user only

### chgrp
Change group ownership
- `chgrp <group> <file>` - Change group
- `chgrp -R <group> <dir>` - Recursive change

### umask
Set default permissions for new files
- `umask 022` - Set default umask
- `umask` - Show current umask

## Process Management

### ps
Show running processes
- `ps aux` - Show all processes with details
- `ps -ef` - Show all processes in full format
- `ps -u <user>` - Show processes for specific user

### top
Display running processes dynamically
- `top` - Interactive process viewer
- `top -u <user>` - Show processes for specific user
- `top -p <pid>` - Monitor specific process

### htop
Enhanced version of top (if installed)
- `htop` - Interactive process viewer with better interface

### kill
Terminate processes
- `kill <pid>` - Send TERM signal to process
- `kill -9 <pid>` - Force kill process (SIGKILL)
- `kill -STOP <pid>` - Stop process
- `kill -CONT <pid>` - Continue stopped process

### killall
Kill processes by name
- `killall <process_name>` - Kill all processes with name
- `killall -9 <process_name>` - Force kill by name

### pgrep/pkill
Find/kill processes by pattern
- `pgrep <pattern>` - Find process IDs by pattern
- `pkill <pattern>` - Kill processes by pattern
- `pkill -f <pattern>` - Match full command line

### jobs
Show active jobs
- `jobs` - List active jobs
- `jobs -l` - List with process IDs

### bg/fg
Background/foreground job control
- `bg %1` - Put job 1 in background
- `fg %1` - Bring job 1 to foreground

### nohup
Run commands immune to hangups
- `nohup <command> &` - Run command in background, immune to hangup

## System Services (systemd)

### systemctl
Control systemd services
- `systemctl status <service>` - Show service status
- `systemctl start <service>` - Start service
- `systemctl stop <service>` - Stop service
- `systemctl restart <service>` - Restart service
- `systemctl reload <service>` - Reload service config
- `systemctl enable <service>` - Enable service at boot
- `systemctl disable <service>` - Disable service at boot
- `systemctl list-units` - List all units
- `systemctl list-services` - List all services

### journalctl
Query systemd journal
- `journalctl` - Show all journal entries
- `journalctl -u <service>` - Show logs for specific service
- `journalctl -f` - Follow journal in real-time
- `journalctl --since "1 hour ago"` - Show recent entries
- `journalctl -p err` - Show only error entries

## Network Commands

### ip
Modern network configuration tool
- `ip addr show` - Show IP addresses
- `ip route show` - Show routing table
- `ip link show` - Show network interfaces
- `ip addr add <ip/mask> dev <interface>` - Add IP address

### ifconfig
Legacy network interface configuration
- `ifconfig` - Show all interfaces
- `ifconfig <interface>` - Show specific interface
- `ifconfig <interface> up/down` - Bring interface up/down

### ping
Test network connectivity
- `ping <host>` - Ping host
- `ping -c 4 <host>` - Send 4 packets only
- `ping -i 2 <host>` - 2 second interval

### wget
Download files from web
- `wget <url>` - Download file
- `wget -O <filename> <url>` - Save with specific name
- `wget -r <url>` - Recursive download
- `wget -c <url>` - Continue partial download

### curl
Transfer data from/to servers
- `curl <url>` - Fetch URL content
- `curl -O <url>` - Save file with original name
- `curl -L <url>` - Follow redirects
- `curl -I <url>` - Show headers only

### netstat
Network statistics
- `netstat -tuln` - Show listening ports
- `netstat -r` - Show routing table
- `netstat -i` - Show interface statistics

### ss
Modern replacement for netstat
- `ss -tuln` - Show listening sockets
- `ss -p` - Show process using socket

## Archive and Compression

### tar
Archive files
- `tar -czf archive.tar.gz <files>` - Create gzip compressed archive
- `tar -xzf archive.tar.gz` - Extract gzip compressed archive
- `tar -tf archive.tar` - List archive contents
- `tar -czf backup.tar.gz --exclude='*.tmp' <dir>` - Create archive excluding pattern

### gzip/gunzip
Compress/decompress files
- `gzip <file>` - Compress file
- `gunzip <file.gz>` - Decompress file
- `gzip -d <file.gz>` - Decompress file

### zip/unzip
Create and extract ZIP archives
- `zip -r archive.zip <dir>` - Create ZIP archive
- `unzip archive.zip` - Extract ZIP archive
- `unzip -l archive.zip` - List ZIP contents

## Text Editors

### nano
Simple text editor
- `nano <file>` - Edit file
- `nano -w <file>` - Disable line wrapping
- `nano +<line> <file>` - Open at specific line

### vim
Advanced text editor
- `vim <file>` - Edit file
- `vim +<line> <file>` - Open at specific line
- `vimdiff <file1> <file2>` - Compare files

## User Management

### su
Switch user
- `su` - Switch to root
- `su <user>` - Switch to specific user
- `su -` - Switch to root with login environment

### sudo
Execute commands as another user
- `sudo <command>` - Run command as root
- `sudo -u <user> <command>` - Run command as specific user
- `sudo -l` - List allowed commands

### passwd
Change password
- `passwd` - Change current user password
- `sudo passwd <user>` - Change another user's password

### useradd
Add user account
- `sudo useradd <username>` - Add user
- `sudo useradd -m <username>` - Add user with home directory
- `sudo useradd -s /bin/bash <username>` - Add user with specific shell

### usermod
Modify user account
- `sudo usermod -aG <group> <user>` - Add user to group
- `sudo usermod -s <shell> <user>` - Change user shell

### userdel
Delete user account
- `sudo userdel <user>` - Delete user
- `sudo userdel -r <user>` - Delete user and home directory

### groups
Show user groups
- `groups` - Show current user's groups
- `groups <user>` - Show specific user's groups

### id
Show user and group IDs
- `id` - Show current user info
- `id <user>` - Show specific user info

## System Monitoring

### uptime
Show system uptime and load
- `uptime` - Show uptime and load averages

### free
Show memory usage
- `free -h` - Human readable format
- `free -m` - Show in MB

### iostat
I/O statistics (if sysstat package installed)
- `iostat` - Show I/O statistics
- `iostat 2` - Update every 2 seconds

### vmstat
Virtual memory statistics
- `vmstat` - Show VM statistics
- `vmstat 2` - Update every 2 seconds

### lscpu
Display CPU information
- `lscpu` - Show CPU details

### lsblk
List block devices
- `lsblk` - Show block devices in tree format
- `lsblk -f` - Show filesystem information

### lsusb
List USB devices
- `lsusb` - Show USB devices
- `lsusb -v` - Verbose output

### lspci
List PCI devices
- `lspci` - Show PCI devices
- `lspci -v` - Verbose output

## Environment and Variables

### env
Show environment variables
- `env` - Display all environment variables
- `env <var>=<value> <command>` - Run command with specific environment

### export
Set environment variables
- `export <VAR>=<value>` - Set environment variable
- `export PATH=$PATH:/new/path` - Add to PATH

### which
Locate command
- `which <command>` - Show path to command

### whereis
Locate binary, source, and manual
- `whereis <command>` - Show locations of command files

### alias
Create command aliases
- `alias ll='ls -la'` - Create alias
- `alias` - Show all aliases
- `unalias <alias>` - Remove alias

## History and Command Line

### history
Command history
- `history` - Show command history
- `history | grep <pattern>` - Search history
- `!!` - Run last command
- `!<n>` - Run command number n

### man
Manual pages
- `man <command>` - Show manual for command
- `man -k <keyword>` - Search manuals by keyword
- `man 5 <file>` - Show manual section 5

### info
Info documents
- `info <command>` - Show info document

### whatis
Brief command description
- `whatis <command>` - Show brief description

### apropos
Search manual descriptions
- `apropos <keyword>` - Find commands related to keyword

## Debian-Specific Commands

### update-alternatives
Manage alternative commands
- `sudo update-alternatives --config <name>` - Configure alternatives
- `sudo update-alternatives --install <link> <name> <path> <priority>` - Install alternative

### dpkg-reconfigure
Reconfigure package
- `sudo dpkg-reconfigure <package>` - Reconfigure package settings
- `sudo dpkg-reconfigure tzdata` - Reconfigure timezone

### update-grub
Update GRUB bootloader
- `sudo update-grub` - Update GRUB configuration

### a2ensite/a2dissite
Apache site management (if Apache installed)
- `sudo a2ensite <site>` - Enable Apache site
- `sudo a2dissite <site>` - Disable Apache site

### service
System V service control (legacy, use systemctl instead)
- `sudo service <service> start` - Start service
- `sudo service <service> status` - Check service status

This reference covers the most commonly used commands in Debian-based systems. Many of these commands have extensive additional options - use `man <command>` to see complete documentation for any command.