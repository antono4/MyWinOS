#!/bin/bash
# =============================================================================
# LFS Build Script - Step 2: Build Temporary System
# =============================================================================

set -e

# Configuration
export LFS=/mnt/lfs
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=/tools/bin:/usr/bin
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

# Function to extract and build packages
build_package() {
    local PKG_NAME=$1
    local PKG_DIR=$2
    local BUILD_CMDS=$3
    
    log_step "Building $PKG_NAME..."
    
    cd $LFS/sources
    
    # Extract
    if [ -f "${PKG_NAME}.tar.xz" ]; then
        tar -xf ${PKG_NAME}.tar.xz
    elif [ -f "${PKG_NAME}.tar.gz" ]; then
        tar -xzf ${PKG_NAME}.tar.gz
    elif [ -f "${PKG_NAME}.tar.bz2" ]; then
        tar -xjf ${PKG_NAME}.tar.bz2
    fi
    
    cd $PKG_DIR
    
    # Build
    eval "$BUILD_CMDS"
    
    cd $LFS/sources
    rm -rf $PKG_DIR
}

# Check prerequisites
if [ ! -d "$LFS/sources" ]; then
    log_error "LFS sources directory not found. Run 01-prepare-system.sh first."
    exit 1
fi

log_info "Starting Temporary System Build..."
log_info "This will build essential toolchain packages..."

# =============================================================================
# Package 1: Binutils (Pass 1)
# =============================================================================
log_step "Building Binutils-2.44 (Pass 1)..."
cd $LFS/sources
tar -xf binutils-2.44.tar.xz
cd binutils-2.44
mkdir -pv build && cd build
../configure --prefix=/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT \
             --disable-nls \
             --disable-werror
make -j$(nproc)
make install
cd $LFS/sources && rm -rf binutils-2.44
log_info "Binutils-2.44 (Pass 1) completed"

# =============================================================================
# Package 2: GCC (Pass 1)
# =============================================================================
log_step "Building GCC-14.2.0 (Pass 1)..."
cd $LFS/sources
tar -xf gcc-14.2.0.tar.xz
cd gcc-14.2.0

# Install GMP
tar -xf $LFS/sources/gmp-6.3.0.tar.xz
mv gmp-6.3.0 gcc/gmp

# Install MPFR
tar -xf $LFS/sources/mpfr-4.2.1.tar.xz
mv mpfr-4.2.1 gcc/mpfr

# Install MPC
tar -xf $LFS/sources/mpc-1.3.1.tar.gz
mv mpc-1.3.1 gcc/mpc

mkdir -pv build && cd build
../configure --prefix=/tools \
             --target=$LFS_TGT \
             --disable-nls \
             --disable-multilib \
             --enable-languages=c \
             --with-sysroot=$LFS \
             --with-newlib \
             --without-headers
make -j$(nproc) all-gcc
make -j$(nproc) all-target-libgcc
make install-gcc
make install-target-libgcc
cd $LFS/sources && rm -rf gcc-14.2.0
log_info "GCC-14.2.0 (Pass 1) completed"

# =============================================================================
# Package 3: Linux API Headers
# =============================================================================
log_step "Building Linux-6.12 API Headers..."
cd $LFS/sources
tar -xf linux-6.12.tar.xz
cd linux-6.12
make mrproper
make headers
find usr/include -type f -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include/* /tools/include/
cd $LFS/sources && rm -rf linux-6.12
log_info "Linux-6.12 API Headers completed"

# =============================================================================
# Package 4: Glibc (Pass 1)
# =============================================================================
log_step "Building Glibc-2.41 (Pass 1)..."
cd $LFS/sources
tar -xf glibc-2.41.tar.xz
cd glibc-2.41
mkdir -pv build && cd build
echo "rootsbindir = /tools/sbin" > configparms
../configure --prefix=/tools \
             --host=$LFS_TGT \
             --build=$(../scripts/config.guess) \
             --enable-kernel=6.0 \
             --with-headers=/tools/include
make -j$(nproc)
make install
cd $LFS/sources && rm -rf glibc-2.41
log_info "Glibc-2.41 (Pass 1) completed"

# =============================================================================
# Package 5: Libstdc++ (for GCC Pass 2)
# =============================================================================
log_step "Building Libstdc++ for GCC..."
cd $LFS/sources
tar -xf gcc-14.2.0.tar.xz
cd gcc-14.2.0

tar -xf $LFS/sources/gmp-6.3.0.tar.xz && mv gmp-6.3.0 gcc/gmp
tar -xf $LFS/sources/mpfr-4.2.1.tar.xz && mv mpfr-4.2.1 gcc/mpfr
tar -xf $LFS/sources/mpc-1.3.1.tar.gz && mv mpc-1.3.1 gcc/mpc

mkdir -pv build && cd build
../libstdc++-v3/configure --prefix=/tools \
                          --host=$LFS_TGT \
                          --disable-multilib \
                          --disable-nls \
                          --disable-libstdcxx-pch
make -j$(nproc)
make install
cd $LFS/sources && rm -rf gcc-14.2.0
log_info "Libstdc++ completed"

# =============================================================================
# Package 6: M4
# =============================================================================
log_step "Building M4-1.4.19..."
cd $LFS/sources
tar -xf m4-1.4.19.tar.xz
cd m4-1.4.19
mkdir -pv build && cd build
../configure --prefix=/tools
make -j$(nproc)
make install
cd $LFS/sources && rm -rf m4-1.4.19
log_info "M4-1.4.19 completed"

# =============================================================================
# Package 7: Ncurses
# =============================================================================
log_step "Building Ncurses-6.5..."
cd $LFS/sources
tar -xf ncurses-6.5.tar.gz
cd ncurses-6.5
sed -i s/mawk// configure
mkdir -pv build && cd build
../configure --prefix=/tools \
             --without-shared \
             --with-cross-compiling=yes \
             --mandir=/tools/share/man
make -j$(nproc)
make install
cd $LFS/sources && rm -rf ncurses-6.5
log_info "Ncurses-6.5 completed"

# =============================================================================
# Package 8: Bash
# =============================================================================
log_step "Building Bash-5.3..."
cd $LFS/sources
tar -xf bash-5.3.tar.gz
cd bash-5.3
mkdir -pv build && cd build
../configure --prefix=/tools \
             --without-bash-malloc \
             --host=$LFS_TGT \
             --build=$(../support/config.guess)
make -j$(nproc)
make install
ln -sf bash /tools/bin/sh
cd $LFS/sources && rm -rf bash-5.3
log_info "Bash-5.3 completed"

# =============================================================================
# Package 9: Coreutils (Pass 1)
# =============================================================================
log_step "Building Coreutils-9.5 (Pass 1)..."
cd $LFS/sources
tar -xf coreutils-9.5.tar.xz
cd coreutils-9.5
./configure --prefix=/tools \
            --host=$LFS_TGT \
            --build=$(build/config.guess)
make -j$(nproc)
make install
cd $LFS/sources && rm -rf coreutils-9.5
log_info "Coreutils-9.5 (Pass 1) completed"

# =============================================================================
# Package 10: Diffutils
# =============================================================================
log_step "Building Diffutils-3.11..."
cd $LFS/sources
tar -xf diffutils-3.11.tar.xz
cd diffutils-3.11
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf diffutils-3.11
log_info "Diffutils-3.11 completed"

# =============================================================================
# Package 11: File
# =============================================================================
log_step "Building File-5.45..."
cd $LFS/sources
tar -xf file-5.45.tar.gz
cd file-5.45
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf file-5.45
log_info "File-5.45 completed"

# =============================================================================
# Package 12: Findutils
# =============================================================================
log_step "Building Findutils-4.10.0..."
cd $LFS/sources
tar -xf findutils-4.10.0.tar.xz
cd findutils-4.10.0
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf findutils-4.10.0
log_info "Findutils-4.10.0 completed"

# =============================================================================
# Package 13: Gawk
# =============================================================================
log_step "Building Gawk-5.3.1..."
cd $LFS/sources
tar -xf gawk-5.3.1.tar.xz
cd gawk-5.3.1
mkdir -pv build && cd build
sed -i 's/exec false/exec true/' ../configure
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf gawk-5.3.1
log_info "Gawk-5.3.1 completed"

# =============================================================================
# Package 14: Grep
# =============================================================================
log_step "Building Grep-3.11..."
cd $LFS/sources
tar -xf grep-3.11.tar.xz
cd grep-3.11
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf grep-3.11
log_info "Grep-3.11 completed"

# =============================================================================
# Package 15: Gzip
# =============================================================================
log_step "Building Gzip-1.13..."
cd $LFS/sources
tar -xf gzip-1.13.tar.xz
cd gzip-1.13
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf gzip-1.13
log_info "Gzip-1.13 completed"

# =============================================================================
# Package 16: Make
# =============================================================================
log_step "Building Make-4.4.1..."
cd $LFS/sources
tar -xf make-4.4.1.tar.gz
cd make-4.4.1
sed -i 's|full_hostname|'$LFS_TGT'|g' glob/glob.c
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT --build=$(../build-aux/config.guess)
make -j$(nproc)
make install
cd $LFS/sources && rm -rf make-4.4.1
log_info "Make-4.4.1 completed"

# =============================================================================
# Package 17: Patch
# =============================================================================
log_step "Building Patch-2.7.6..."
cd $LFS/sources
tar -xf patch-2.7.6.tar.xz
cd patch-2.7.6
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf patch-2.7.6
log_info "Patch-2.7.6 completed"

# =============================================================================
# Package 18: Sed
# =============================================================================
log_step "Building Sed-4.9..."
cd $LFS/sources
tar -xf sed-4.9.tar.xz
cd sed-4.9
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf sed-4.9
log_info "Sed-4.9 completed"

# =============================================================================
# Package 19: Tar
# =============================================================================
log_step "Building Tar-1.35..."
cd $LFS/sources
tar -xf tar-1.35.tar.xz
cd tar-1.35
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf tar-1.35
log_info "Tar-1.35 completed"

# =============================================================================
# Package 20: Xz
# =============================================================================
log_step "Building Xz-5.6.3..."
cd $LFS/sources
tar -xf xz-5.6.3.tar.xz
cd xz-5.6.3
mkdir -pv build && cd build
../configure --prefix=/tools --host=$LFS_TGT
make -j$(nproc)
make install
cd $LFS/sources && rm -rf xz-5.6.3
log_info "Xz-5.6.3 completed"

log_info "========================================"
log_info "Temporary System Build Complete!"
log_info "========================================"
log_info "Next step: Run 03-final-system.sh"
