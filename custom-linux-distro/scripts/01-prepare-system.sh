#!/bin/bash
# =============================================================================
# LFS Build Script - Step 1: System Preparation
# =============================================================================

set -e

# Configuration
export LFS=/mnt/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export MAKEFLAGS="-j$(nproc)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    log_error "Please run as root"
    exit 1
fi

log_info "Starting LFS System Preparation..."

# Step 1.1: Create Directory Structure
log_info "Creating directory structure..."
mkdir -pv $LFS/{sources,tools,bin,etc,var,lib64,sbin,run,media,mnt,opt,srv,var/log}
mkdir -pv $LFS/{bin,boot,dev,etc/rc.d,home,lib,lib64,media,mnt,opt,proc,root,sbin,srv,sys,tmp,usr/local,usr/src}
mkdir -pv $LFS/{usr/bin,usr/lib,usr/sbin,usr/include,usr/share,usr/src}
mkdir -pv $LFS/etc/{rc.d/rc0.d,rc.d/rc1.d,rc.d/rc2.d,rc.d/rc3.d,rc.d/rc4.d,rc.d/rc5.d,rc.d/rc6.d,rc.d/rcsysinit.d,rc.d/rcS.d,skel}
mkdir -pv $LFS/var/{cache,log,mail,spool,lock,run,tmp}
ln -sfv $LFS/tools /

# Step 1.2: Create Essential Symlinks
log_info "Creating essential symlinks..."
ln -sfv /tools/bin/bash /bin/bash
ln -sfv /tools/bin/bash /tools/bin/sh
ln -sfv /tools/bin/cat /bin/cat
ln -sfv /tools/bin/echo /bin/echo
ln -sfv /tools/bin/env /bin/env
ln -sfv /tools/bin/false /bin/false
ln -sfv /tools/bin/pwd /bin/pwd
ln -sfv /tools/bin/readlink /bin/readlink
ln -sfv /tools/bin/rm /bin/rm
ln -sfv /tools/bin/rmdir /bin/rmdir
ln -sfv /tools/bin/stty /bin/stty
ln -sfv /tools/bin/true /bin/true
ln -sfv /tools/bin/test /usr/bin/test
ln -sfv /tools/bin/test /bin/[

# Create lib symlinks
ln -sfv /tools/lib/libgcc_s.so.1 /lib/libgcc_s.so.1
ln -sfv /tools/lib/libstdc++.so.6 /lib/libstdc++.so.6
ln -sfv /tools/lib/libstdc++.a /lib/libstdc++.a
ln -sfv /tools/lib/libc.so.6 /lib/libc.so.6
ln -sfv /tools/lib/libc.a /lib/libc.a
ln -sfv /tools/lib/libc.so /lib/libc.so

# Step 1.3: Create /etc/passwd
log_info "Creating /etc/passwd..."
cat > $LFS/etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:2:2:daemon:/dev/null:/bin/false
nobody:x:99:99:Nobody:/dev/null:/bin/false
EOF

# Step 1.4: Create /etc/group
log_info "Creating /etc/group..."
cat > $LFS/etc/group << "EOF"
root:x:0:
bin:x:1:
daemon:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
wheel:x:10:
EOF

# Step 1.5: Create /etc/hosts
log_info "Creating /etc/hosts..."
cat > $LFS/etc/hosts << "EOF"
127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
EOF

# Step 1.6: Create /etc/fstab
log_info "Creating /etc/fstab..."
cat > $LFS/etc/fstab << "EOF"
# file system  mount-point  type     options                     dump  fsck
/dev/sda2     /            ext4     defaults                    1     1
/dev/sda1     /boot        ext4     defaults                    1     2
/dev/sda3     swap         swap     pri=1                       0     0
proc          /proc        proc     defaults                    0     0
sysfs         /sys         sysfs    defaults                    0     0
devpts        /dev/pts     devpts   gid=4,mode=620              0     0
tmpfs         /run         tmpfs    defaults                    0     0
devshm        /dev/shm     tmpfs    defaults                    0     0
EOF

# Step 1.7: Create /etc/profile
log_info "Creating /etc/profile..."
cat > $LFS/etc/profile << "EOF"
# /etc/profile
# Set up the environment

set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin:/usr/local/bin
if [ -n "$BASH_VERSION" ]; then
    for dir in /etc/profile.d; do
        if [ -r "$dir" ] && [ -d "$dir" ]; then
            for script in $dir/*.sh; do
                [ -r "$script" ] && . "$script"
            done
        fi
    done
fi
export LFS LC_ALL LFS_TGT PATH
EOF

# Step 1.8: Create /etc/bashrc
log_info "Creating /etc/bashrc..."
cat > $LFS/etc/bashrc << "EOF"
# /etc/bashrc

# Set default umask
umask 022

# Set prompt
PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
EOF

# Step 1.9: Create /etc/lfs-release
log_info "Creating version files..."
echo "12.0" > $LFS/etc/lfs-release
cat > $LFS/etc/lsb-release << "EOF"
DISTRIB_ID="MyLFS"
DISTRIB_RELEASE="12.0"
DISTRIB_CODENAME="custom"
DISTRIB_DESCRIPTION="My Custom Linux Distribution"
EOF

log_info "System preparation completed successfully!"
log_info "Next step: Run 02-temp-system.sh to build temporary tools"
