# Copyright (c) 2021 Huawei Device Co., Ltd.
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# ohos makefile to build kernel
PRODUCT_NAME=$(TARGET_PRODUCT)

OHOS_BUILD_HOME := $(OHOS_ROOT_PATH)
BOOT_IMAGE_PATH = $(OHOS_BUILD_HOME)/device/hisilicon/hispark_taurus/prebuilts
KERNEL_SRC_TMP_PATH := $(OUT_DIR)/kernel/src_tmp/kernel_linux

KERNEL_SRC_PATH := $(OHOS_BUILD_HOME)/kernel/kernel_linux
PREBUILTS_GCC_DIR := $(OHOS_BUILD_HOME)/prebuilts/gcc
PREBUILTS_CLANG_DIR := $(OHOS_BUILD_HOME)/prebuilts/clang
CLANG_HOST_TOOLCHAIN := $(PREBUILTS_CLANG_DIR)/host/linux-x86/clang-r353983c/bin
KERNEL_HOSTCC := $(CLANG_HOST_TOOLCHAIN)/clang
KERNEL_PREBUILT_MAKE := make

ERNEL_ARCH_ARM := arm
KERNEL_TARGET_TOOLCHAIN := $(PREBUILTS_GCC_DIR)/linux-x86/arm/gcc-linaro-7.5.0-arm-linux-gnueabi/bin
KERNEL_TARGET_TOOLCHAIN_PREFIX := $(KERNEL_TARGET_TOOLCHAIN)/arm-linux-gnueabi-
CLANG_CC := $(CLANG_HOST_TOOLCHAIN)/clang

KERNEL_PERL := /usr/bin/perl

KERNEL_CROSS_COMPILE :=
KERNEL_CROSS_COMPILE += CC="$(CLANG_CC)"
KERNEL_CROSS_COMPILE += HOSTCC="$(KERNEL_HOSTCC)"
KERNEL_CROSS_COMPILE += PERL=$(KERNEL_PERL)
KERNEL_CROSS_COMPILE += CROSS_COMPILE="$(KERNEL_TARGET_TOOLCHAIN_PREFIX)"
KERNEL_CROSS_COMPILE += ARCH_CFLAGS=-Wno-self-assign -Wno-unused-variable 
KERNEL_CROSS_COMPILE += LOADADDR=0x80008000

KERNEL_MAKE := \
    PATH="$(BOOT_IMAGE_PATH):$$PATH" \
    $(KERNEL_PREBUILT_MAKE)


KERNEL_IMAGE_FILE := $(KERNEL_SRC_TMP_PATH)/arch/arm/boot/uImage
DEFCONFIG_FILE := imx6ull_defconfig
export HDF_PROJECT_ROOT=$(OHOS_BUILD_HOME)/

$(KERNEL_IMAGE_FILE):
	$(hide) echo "build kernel..."
	$(hide) rm -rf $(KERNEL_SRC_TMP_PATH);mkdir -p $(KERNEL_SRC_TMP_PATH);cp -arfL $(KERNEL_SRC_PATH)/* $(KERNEL_SRC_TMP_PATH)/
	$(hide) $(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(ERNEL_ARCH_ARM) $(KERNEL_CROSS_COMPILE) distclean
	$(hide) $(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(ERNEL_ARCH_ARM) $(KERNEL_CROSS_COMPILE) $(DEFCONFIG_FILE)
	$(hide) $(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(ERNEL_ARCH_ARM) $(KERNEL_CROSS_COMPILE) -j64 uImage

.PHONY: build-kernel
build-kernel: $(KERNEL_IMAGE_FILE)
