#!/bin/bash
# =============================================================================
# LFS Build Script - Step 4: System Configuration
# =============================================================================

set -e

# Configuration
export LFS=/mnt/lfs

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}==>${NC} ${BLUE}$1${NC}"; }

# Check prerequisites
if [ ! -d "$LFS/bin" ]; then
    log_error "Final system not built. Run 03-final-system.sh first."
    exit 1
fi

log_info "Starting System Configuration..."

# =============================================================================
# Create /etc/passwd
# =============================================================================
log_step "Creating /etc/passwd..."
cat > $LFS/etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:2:2:daemon:/dev/null:/bin/false
nobody:x:99:99:Nobody:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon:/dev/null:/bin/false
systemd-journal-gateway:x:191:191:Journal Gateway:/run/systemd/journal-gateway:/bin/false
systemd-network:x:192:192:systemd Network Management:/:/bin/false
systemd-resolve:x:193:193:systemd Resolver:/:/bin/false
systemd-timesync:x:194:194:systemd Time Synchronization:/:/bin/false
EOF

# =============================================================================
# Create /etc/group
# =============================================================================
log_step "Creating /etc/group..."
cat > $LFS/etc/group << "EOF"
root:x:0:
bin:x:1:
daemon:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
disk:x:6:
lp:x:7:
wifi:x:10:
kmem:x:11:
input:x:12:
mail:x:13:
news:x:14:
uucp:x:15:
man:x:15:
dialout:x:18:
floppy:x:19:
games:x:20:
tape:x:30:
video:x:39:
audio:x:39:
users:x:100:
nobody:x:99:
messagebus:x:18:
systemd-journal:x:191:
systemd-network:x:192:
systemd-resolve:x:193:
systemd-timesync:x:194:
EOF

# =============================================================================
# Create /etc/fstab
# =============================================================================
log_step "Creating /etc/fstab..."
cat > $LFS/etc/fstab << "EOF"
# /etc/fstab - Static file system information
#
# <file system>  <mount point>  <type>  <options>                      <dump>  <pass>

# Root filesystem
/dev/sda2      /               ext4    defaults                        1     1

# Boot partition
/dev/sda1      /boot           ext4    defaults                        1     2

# Swap partition
/dev/sda3      swap            swap    pri=1                           0     0

# Additional filesystems
proc           /proc           proc    defaults                        0     0
sysfs          /sys            sysfs   defaults                        0     0
devpts         /dev/pts        devpts  gid=4,mode=620                  0     0
tmpfs          /run            tmpfs   defaults                        0     0
devshm         /dev/shm        tmpfs   defaults                        0     0
EOF

# =============================================================================
# Create /etc/hosts
# =============================================================================
log_step "Creating /etc/hosts..."
cat > $LFS/etc/hosts << "EOF"
127.0.0.1 localhost.localdomain localhost
127.0.1.1 mylfs.localdomain mylfs
::1 localhost localhost.localdomain ip6-localhost ip6-loopback
EOF

# =============================================================================
# Create /etc/profile
# =============================================================================
log_step "Creating /etc/profile..."
cat > $LFS/etc/profile << "EOF"
# /etc/profile
# System-wide environment and startup programs

# Set up the environment
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
export LFS LC_ALL LFS_TGT PATH

# Set default locale
export LANG=en_US.UTF-8

# Set up color prompt
PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '

# Enable color support for ls
eval "$(dircolors -b)"

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Load profile.d scripts
for script in /etc/profile.d/*.sh; do
    [ -r "$script" ] && source "$script"
done

# User specific environment
if [ -d ~/.bashrc ]; then
    source ~/.bashrc
fi
EOF

# =============================================================================
# Create /etc/bashrc
# =============================================================================
log_step "Creating /etc/bashrc..."
cat > $LFS/etc/bashrc << "EOF"
# /etc/bashrc

# Set default umask
umask 022

# Set prompt
if [ "$EUID" -eq 0 ]; then
    PS1='\[\033[1;31m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]# '
else
    PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]$ '
fi

# Enable color support
eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
EOF

# =============================================================================
# Create /etc/sysconfig/console
# =============================================================================
log_step "Creating /etc/sysconfig..."
mkdir -pv $LFS/etc/sysconfig
cat > $LFS/etc/sysconfig/console << "EOF"
# Console font configuration
FONT=lat0-16
FONTMAP=8859-1
KEYMAP=us
EOF

# =============================================================================
# Create /etc/sysconfig/network
# =============================================================================
cat > $LFS/etc/sysconfig/network << "EOF"
# Network configuration
NETWORKING=yes
HOSTNAME=mylfs
EOF

# =============================================================================
# Create /etc/sysconfig/network-devices/ifconfig.eth0
# =============================================================================
mkdir -pv $LFS/etc/sysconfig/network-devices
cat > $LFS/etc/sysconfig/network-devices/ifconfig.eth0 << "EOF"
ONBOOT=yes
SERVICE=dhcpcd
DHCP_START=
DHCP_STOP=
IPV6INIT=yes
IPV6_AUTOCONF=yes
EOF

# =============================================================================
# Create /etc/resolv.conf
# =============================================================================
cat > $LFS/etc/resolv.conf << "EOF"
# DNS configuration
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF

# =============================================================================
# Create /etc/shells
# =============================================================================
log_step "Creating /etc/shells..."
cat > $LFS/etc/shells << "EOF"
/bin/sh
/bin/bash
/usr/bin/sh
/usr/bin/bash
EOF

# =============================================================================
# Create /etc/inputrc
# =============================================================================
log_step "Creating /etc/inputrc..."
cat > $LFS/etc/inputrc << "EOF"
# /etc/inputrc - Readline initialization

set horizontal-scroll-mode Off
set meta-flag On
set input-meta On
set convert-meta Off
set output-meta On
set show-all-if-ambiguous On
set show-all-if-unmodified On
set visible-stats On

# Enable 8-bit input
set meta-flag on
set input-meta on
set convert-meta off
set output-meta on

# Colors for tab completion
set colored-stats On
set colored-completion-prefix On
set colored-completion-results On

# Don't ring bell on completion
set bell-style none

# Keyboard mappings
"\eOd": backward-word
"\eOc": forward-word

# Completion options
set completion-ignore-case On
set completion-map-case On
EOF

# =============================================================================
# Create /etc/vimrc
# =============================================================================
log_step "Creating /etc/vimrc..."
cat > $LFS/etc/vimrc << "EOF"
" /etc/vimrc - Vim configuration

" General settings
set nocompatible
set backspace=indent,eol,start
set history=50
set undofile
set swapfile

" Display settings
syntax on
set background=dark
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8

" UI settings
set showmode
set showcmd
set ruler
set wildmenu
set wildmode=list:longest,full
set laststatus=2

" Indentation
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Search settings
set incsearch
set hlsearch
set ignorecase
set smartcase

" File settings
set autoread
set autowrite

" Editor settings
set number
set cursorline
set colorcolumn=80

" Disable backup files
set nobackup
set nowritebackup
set noswapfile
EOF

# =============================================================================
# Create /etc/lsb-release
# =============================================================================
log_step "Creating distribution info..."
cat > $LFS/etc/lsb-release << "EOF"
DISTRIB_ID="MyLFS"
DISTRIB_RELEASE="12.0"
DISTRIB_CODENAME="Custom"
DISTRIB_DESCRIPTION="My Custom Linux Distribution"
EOF

cat > $LFS/etc/os-release << "EOF"
NAME="My Custom Linux"
VERSION="12.0"
ID=mylfs
PRETTY_NAME="My Custom Linux 12.0"
VERSION_ID="12.0"
EOF

echo "12.0" > $LFS/etc/lfs-release

# =============================================================================
# Create /root/.bashrc
# =============================================================================
log_step "Creating root user configuration..."
mkdir -pv $LFS/root
cat > $LFS/root/.bashrc << "EOF"
# /root/.bashrc
# Root user specific settings

# Set PATH
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias ls='ls --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ports='netstat -tulanp'

# Prompt
PS1='\[\033[1;31m\]\h \[\033[1;34m\]\W \[\033[0m\]\$ '

# History
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend

# Welcome message
echo "Welcome to My Custom Linux Distribution!"
echo "Kernel: $(uname -r)"
echo ""
EOF

cat > $LFS/root/.bash_profile << "EOF"
# /root/.bash_profile
# Executed for login shells

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
EOF

# =============================================================================
# Create /etc/profile.d scripts
# =============================================================================
log_step "Creating profile.d scripts..."
mkdir -pv $LFS/etc/profile.d
cat > $LFS/etc/profile.d/lfs.sh << "EOF"
# LFS System identification
export LFS=/mnt/lfs
EOF

cat > $LFS/etc/profile.d/bash_completion.sh << "EOF"
# Bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
EOF

# =============================================================================
# Create /etc/issue (login banner)
# =============================================================================
log_step "Creating login banner..."
cat > $LFS/etc/issue << "EOF"
My Custom Linux 12.0
Kernel \r on an \m
\r\n
EOF

cat > $LFS/etc/motd << "EOF"
================================================================================
        Welcome to My Custom Linux Distribution (MyLFS)
================================================================================

Information:
  Distribution: My Custom Linux 12.0
  Kernel:       $(uname -r)
  Architecture: $(uname -m)
  Uptime:        $(uptime -p)

For system documentation, please visit:
  https://www.linuxfromscratch.org/

================================================================================
EOF

# =============================================================================
# Set up locales
# =============================================================================
log_step "Setting up locales..."
cat > $LFS/etc/locale.conf << "EOF"
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
EOF

# =============================================================================
# Create /etc/skel files
# =============================================================================
log_step "Creating skeleton files..."
mkdir -pv $LFS/etc/skel
cat > $LFS/etc/skel/.bashrc << "EOF"
# ~/.bashrc
# User specific settings

# Set PATH
export PATH=/usr/local/bin:$PATH:$HOME/.local/bin

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias ls='ls --color=auto'

# History
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend

# Prompt
PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '
EOF

cat > $LFS/etc/skel/.bash_profile << "EOF"
# ~/.bash_profile
# Executed for login shells

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
EOF

cat > $LFS/etc/skel/.profile << "EOF"
# ~/.profile
# Executed by the command interpreter for login shells

# Set PATH
export PATH=/usr/local/bin:$PATH

# Set locale
export LANG=en_US.UTF-8
EOF

# =============================================================================
# Create log files
# =============================================================================
log_step "Creating log files..."
mkdir -pv $LFS/var/log/{btmp,wtmp,lastlog,faillog}
touch $LFS/var/log/lastlog
touch $LFS/var/log/wtmp
touch $LFS/var/log/faillog
chmod -v 664 $LFS/var/log/lastlog
chmod -v 664 $LFS/var/log/wtmp
chmod -v 600 $LFS/var/log/faillog

log_info "========================================"
log_info "System Configuration Complete!"
log_info "========================================"
log_info "Next step: Run 05-bootloader.sh to install bootloader"
