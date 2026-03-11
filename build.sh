#!/bin/bash

export PATH="/clang/kernel/linux-x86/clang-r416183b/bin:$PATH"

echo "Cleaning up old build files..."
rm -rf out/

MAKE_ARGS="O=out ARCH=arm64 LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- CONFIG_SHELL=/bin/bash"

echo "Building a configuration for Dizi (GKI + Vendor)..."
make $MAKE_ARGS gki_defconfig vendor/dizi_GKI.config
make $MAKE_ARGS olddefconfig

CLANG_FLAGS="-Wno-error=frame-larger-than= -Wno-error=shift-count-overflow -Wno-unused-function"

echo "Starting main kernel compilation..."
make -j$(nproc) $MAKE_ARGS KCFLAGS="$CLANG_FLAGS"
