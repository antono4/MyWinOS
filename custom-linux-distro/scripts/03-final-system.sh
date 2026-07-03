#!/bin/bash
# =============================================================================
# LFS Build Script - Step 3: Build Final System
# =============================================================================

set -e

# Configuration
export LFS=/mnt/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=/bin:/usr/bin:/tools/bin:/bin
export MAKEFLAGS="-j$(nproc)"

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
if [ ! -d "$LFS/tools" ]; then
    log_error "Temporary system not built. Run 02-temp-system.sh first."
    exit 1
fi

log_info "Starting Final System Build..."
log_info "This will build the complete Linux system..."

# Change ownership to root
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin}

# =============================================================================
# Package 1: Binutils (Pass 2)
# =============================================================================
log_step "Building Binutils-2.41 (Pass 2)..."
cd $LFS/sources
tar -xf binutils-2.41.tar.xz
cd binutils-2.41
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure --prefix=/usr \
             --host=$LFS_TGT \
             --build=$(../config.guess) \
             --disable-nls \
             --enable-gold \
             --enable-ld=default \
             --with-sysroot=$LFS \
             --enable-plugins
make -j$(nproc)
make DESTDIR=$LFS install -j1
cd $LFS/sources && rm -rf binutils-2.41
log_info "Binutils-2.41 (Pass 2) completed"

# =============================================================================
# Package 2: GCC (Pass 2)
# =============================================================================
log_step "Building GCC-13.2.0 (Pass 2)..."
cd $LFS/sources
tar -xf gcc-13.2.0.tar.xz
cd gcc-13.2.0

tar -xf $LFS/sources/gmp-6.3.0.tar.xz && mv gmp-6.3.0 gcc/gmp
tar -xf $LFS/sources/mpfr-4.2.0.tar.xz && mv mpfr-4.2.0 gcc/mpfr
tar -xf $LFS/sources/mpc-1.3.1.tar.gz && mv mpc-1.3.1 gcc/mpc

cat gcc/limitx.h gcc/glimits.h gccLIMITS_H > gcc/include/limits.h
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure --prefix=/usr \
             --host=$LFS_TGT \
             --build=$(../config.guess) \
             --with-sysroot=$LFS \
             --enable-languages=c,c++ \
             --disable-multilib \
             --disable-bootstrap
make -j$(nproc)
make DESTDIR=$LFS install -j1
ln -sfv gcc $LFS/usr/bin/cc
cd $LFS/sources && rm -rf gcc-13.2.0
log_info "GCC-13.2.0 (Pass 2) completed"

# =============================================================================
# Package 3: Linux API Headers
# =============================================================================
log_step "Building Linux-6.4 API Headers (Final)..."
cd $LFS/sources
tar -xf linux-6.4.tar.xz
cd linux-6.4
make mrproper
make headers
find usr/include -type f -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include/* /usr/include/
cd $LFS/sources && rm -rf linux-6.4
log_info "Linux-6.4 API Headers completed"

# =============================================================================
# Package 4: Glibc (Final)
# =============================================================================
log_step "Building Glibc-2.38 (Final)..."
cd $LFS/sources
tar -xf glibc-2.38.tar.xz
cd glibc-2.38
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure --prefix=/usr \
             --host=$LFS_TGT \
             --build=$(../scripts/config.guess) \
             --enable-kernel=4.14 \
             --with-headers=/usr/include \
             libc_cv_slibdir=/lib \
             libc_cv_ctors_header=yes
make -j$(nproc)
make DESTDIR=$LFS install
cp -v nscd/nscd.conf $LFS/etc/nscd.conf
mkdir -pv $LFS/var/cache/nscd
cd $LFS/sources && rm -rf glibc-2.38
log_info "Glibc-2.38 completed"

# =============================================================================
# Package 5: Libstdc++ (Final)
# =============================================================================
log_step "Building Libstdc++ (Final)..."
cd $LFS/sources
tar -xf gcc-13.2.0.tar.xz
cd gcc-13.2.0

tar -xf $LFS/sources/gmp-6.3.0.tar.xz && mv gmp-6.3.0 gcc/gmp
tar -xf $LFS/sources/mpfr-4.2.0.tar.xz && mv mpfr-4.2.0 gcc/mpfr
tar -xf $LFS/sources/mpc-1.3.1.tar.gz && mv mpc-1.3.1 gcc/mpc

mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../libstdc++-v3/configure --prefix=/usr \
                          --host=$LFS_TGT \
                          --disable-multilib \
                          --disable-nls \
                          --disable-libstdcxx-pch
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf gcc-13.2.0
log_info "Libstdc++ completed"

# =============================================================================
# Package 6: M4
# =============================================================================
log_step "Building M4-1.4.19..."
cd $LFS/sources
tar -xf m4-1.4.19.tar.xz
cd m4-1.4.19
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf m4-1.4.19
log_info "M4 completed"

# =============================================================================
# Package 7: Ncurses
# =============================================================================
log_step "Building Ncurses-6.4..."
cd $LFS/sources
tar -xf ncurses-6.4.tar.gz
cd ncurses-6.4
sed -i s/mawk// configure
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
../configure --prefix=/usr \
             --host=$LFS_TGT \
             --with-shared \
             --without-normal \
             --mandir=/usr/share/man
make -j$(nproc)
make DESTDIR=$LFS install
ln -sfv libcurses.so $LFS/usr/lib/libcurses.so
cd $LFS/sources && rm -rf ncurses-6.4
log_info "Ncurses completed"

# =============================================================================
# Package 8: Bash
# =============================================================================
log_step "Building Bash-5.2.15..."
cd $LFS/sources
tar -xf bash-5.2.15.tar.gz
cd bash-5.2.15
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
../configure --prefix=/usr \
             --host=$LFS_TGT \
             --build=$(../support/config.guess) \
             --without-bash-malloc
make -j$(nproc)
make DESTDIR=$LFS install
ln -sfv bash $LFS/bin/sh
cd $LFS/sources && rm -rf bash-5.2.15
log_info "Bash completed"

# =============================================================================
# Package 9: Coreutils
# =============================================================================
log_step "Building Coreutils-9.3..."
cd $LFS/sources
tar -xf coreutils-9.3.tar.xz
cd coreutils-9.3
sed -i '/SELINUX/ s/0/1' configure.ac
touch man/*.x
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
../configure --prefix=/usr \
             --host=$LFS_TGT \
             --build=$(../build-aux/config.guess) \
             --enable-install-program=hostname
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf coreutils-9.3
log_info "Coreutils completed"

# =============================================================================
# Package 10: Diffutils
# =============================================================================
log_step "Building Diffutils-3.10..."
cd $LFS/sources
tar -xf diffutils-3.10.tar.xz
cd diffutils-3.10
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf diffutils-3.10
log_info "Diffutils completed"

# =============================================================================
# Package 11: File
# =============================================================================
log_step "Building File-5.45..."
cd $LFS/sources
tar -xf file-5.45.tar.gz
cd file-5.45
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf file-5.45
log_info "File completed"

# =============================================================================
# Package 12: Findutils
# =============================================================================
log_step "Building Findutils-4.9.0..."
cd $LFS/sources
tar -xf findutils-4.9.0.tar.xz
cd findutils-4.9.0
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf findutils-4.9.0
log_info "Findutils completed"

# =============================================================================
# Package 13: Gawk
# =============================================================================
log_step "Building Gawk-5.2.2..."
cd $LFS/sources
tar -xf gawk-5.2.2.tar.xz
cd gawk-5.2.2
sed -i 's/exec false/exec true/' configure
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf gawk-5.2.2
log_info "Gawk completed"

# =============================================================================
# Package 14: Grep
# =============================================================================
log_step "Building Grep-3.11..."
cd $LFS/sources
tar -xf grep-3.11.tar.xz
cd grep-3.11
mkdir -pv build && cd build
sed -i 's/mflag=/mflag=/; s/007)/007)/; s/mngettext/mngettext/' grep.c
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf grep-3.11
log_info "Grep completed"

# =============================================================================
# Package 15: Gzip
# =============================================================================
log_step "Building Gzip-1.12..."
cd $LFS/sources
tar -xf gzip-1.12.tar.xz
cd gzip-1.12
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf gzip-1.12
log_info "Gzip completed"

# =============================================================================
# Package 16: Make
# =============================================================================
log_step "Building Make-4.4.1..."
cd $LFS/sources
tar -xf make-4.4.1.tar.gz
cd make-4.4.1
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf make-4.4.1
log_info "Make completed"

# =============================================================================
# Package 17: Patch
# =============================================================================
log_step "Building Patch-2.7.6..."
cd $LFS/sources
tar -xf patch-2.7.6.tar.xz
cd patch-2.7.6
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf patch-2.7.6
log_info "Patch completed"

# =============================================================================
# Package 18: Sed
# =============================================================================
log_step "Building Sed-4.9..."
cd $LFS/sources
tar -xf sed-4.9.tar.xz
cd sed-4.9
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf sed-4.9
log_info "Sed completed"

# =============================================================================
# Package 19: Tar
# =============================================================================
log_step "Building Tar-1.34..."
cd $LFS/sources
tar -xf tar-1.34.tar.xz
cd tar-1.34
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf tar-1.34
log_info "Tar completed"

# =============================================================================
# Package 20: Xz
# =============================================================================
log_step "Building Xz-5.4.4..."
cd $LFS/sources
tar -xf xz-5.4.4.tar.xz
cd xz-5.4.4
mkdir -pv build && cd build
CC=$LFS_TGT-gcc ../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf xz-5.4.4
log_info "Xz completed"

# =============================================================================
# Package 21: Bzip2
# =============================================================================
log_step "Building Bzip2-1.0.8..."
cd $LFS/sources
tar -xf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8
CC=$LFS_TGT-gcc make -j$(nproc)
make PREFIX=/usr install
cp -v bzip2-shared $LFS/bin/bzip2
cp -av libbz2.so* $LFS/lib
ln -sv libbz2.so.* $LFS/usr/lib/libbz2.so
cd $LFS/sources && rm -rf bzip2-1.0.8
log_info "Bzip2 completed"

# =============================================================================
# Package 22: Flex
# =============================================================================
log_step "Building Flex-2.6.4..."
cd $LFS/sources
tar -xf flex-2.6.4.tar.gz
cd flex-2.6.4
sed -i "/#ifdef HAVE_XTREGEX_H/as #ifdef _REENTRANT\n #include <regex.h>\n#endif" src/flexdef.h
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
ln -sfv flex $LFS/usr/bin/lex
cd $LFS/sources && rm -rf flex-2.6.4
log_info "Flex completed"

# =============================================================================
# Package 23: Perl
# =============================================================================
log_step "Building Perl-5.36.1..."
cd $LFS/sources
tar -xf perl-5.36.1.tar.xz
cd perl-5.36.1
sh Configure -des \
    -Dprefix=/usr \
    -Dvendorprefix=/usr \
    -Dprivlib=/usr/lib/perl5/5.36/core_perl \
    -Darchlib=/usr/lib/perl5/5.36/core_perl \
    -Dsiteprefix=/usr \
    -Dsitelib=/usr/lib/perl5/5.36/site_perl \
    -Dsitearch=/usr/lib/perl5/5.36/site_perl \
    -Dusethreads \
    -Dtargethost=$LFS_TGT
make -j$(nproc) TEST_JOBS=1
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf perl-5.36.1
log_info "Perl completed"

# =============================================================================
# Package 24: Python
# =============================================================================
log_step "Building Python-3.11.4..."
cd $LFS/sources
tar -xf Python-3.11.4.tar.xz
cd Python-3.11.4
sed -i '/def free_mem/:,/^    return/{"N;N;s/freemem/free_mem/}' Modules/_tkinter.c
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
./configure --prefix=/usr \
            --host=$LFS_TGT \
            --build=$(../config.guess) \
            --enable-shared \
            --without-ensurepip
make -j$(nproc)
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf Python-3.11.4
log_info "Python completed"

# =============================================================================
# Package 25: Vim
# =============================================================================
log_step "Building Vim-9.0..."
cd $LFS/sources
tar -xf vim-9.0.tar.gz
cd vim-9.0
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
../configure --prefix=/usr --host=$LFS_TGT
make -j$(nproc)
make DESTDIR=$LFS install
ln -sfv vim $LFS/usr/bin/vi
cat > $LFS/etc/vimrc << "EOF"
" /etc/vimrc
set nocompatible
set backspace=2
syntax on
set encoding=utf-8
EOF
cd $LFS/sources && rm -rf vim-9.0
log_info "Vim completed"

# =============================================================================
# Package 26: Systemd (Optional - for modern init system)
# =============================================================================
log_step "Building Systemd-253..."
cd $LFS/sources
tar -xf systemd-253.tar.gz
cd systemd-253
mkdir -pv build && cd build
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
meson setup \
    --prefix=/usr \
    --buildtype=release \
    --default-library=shared \
    ..
ninja -j$(nproc)
ninja DESTDIR=$LFS install
cd $LFS/sources && rm -rf systemd-253
log_info "Systemd completed"

# =============================================================================
# Create symlinks for system
# =============================================================================
log_step "Creating system symlinks..."
ln -sfv /tools/bin/bash $LFS/bin/bash
ln -sfv bash $LFS/bin/sh
ln -sfv /tools/bin/bash $LFS/usr/bin/bash
ln -sfv /lib $LFS/lib64

# Create mtab
ln -sfv /proc/self/mounts $LFS/etc/mtab

log_info "========================================"
log_info "Final System Build Complete!"
log_info "========================================"
log_info "Next step: Run 04-config-system.sh"
