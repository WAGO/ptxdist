# -*-makefile-*-
#
# Copyright (C) 2003, 2009, 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#           (C) 2008 by Wolfram Sang <w.sang@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

kernel-version-split = $(subst -, ,$(subst ., ,$($(strip $(1))_VERSION)))
kernel-major = $(word 1,$(call kernel-version-split, $(1)))
kernel-minor = $(word 2,$(call kernel-version-split, $(1)))
kernel-micro = $(word 3,$(call kernel-version-split, $(1)))

KERNEL_VERSION		:= $(call remove_quotes,$(PTXCONF_KERNEL_VERSION))
KERNEL_VERSION_MAJOR	:= $(call kernel-major,KERNEL)
KERNEL_VERSION_MINOR	:= $(call kernel-minor,KERNEL)
KERNEL_VERSION_MICRO	:= $(call kernel-micro,KERNEL)

KERNEL_HEADER_VERSION		:= $(call remove_quotes,$(PTXCONF_KERNEL_HEADER_VERSION))
KERNEL_HEADER_VERSION_MAJOR	:= $(call kernel-major,KERNEL_HEADER)
KERNEL_HEADER_VERSION_MINOR	:= $(call kernel-minor,KERNEL_HEADER)
KERNEL_HEADER_VERSION_MICRO	:= $(call kernel-micro,KERNEL_HEADER)

GENERIC_KERNEL_ARCH := $(PTXCONF_ARCH_STRING)
ifdef PTXCONF_ARCH_X86
GENERIC_KERNEL_ARCH := "x86"
endif
ifdef PTXCONF_ARCH_PPC
GENERIC_KERNEL_ARCH := "powerpc"
endif

#
# Starting with 4.12-rc1, Linus no longer provides signed tarballs for
# pre-release ("-rc") kernels. Download the version automatically generated
# by cgit.
#
ifneq ($(findstring -rc,$(KERNEL_VERSION)),)
KERNEL_NEEDS_GIT_URL := $(call ptx/force-sh, test $(KERNEL_VERSION_MAJOR) -ge 5 -o \( $(KERNEL_VERSION_MAJOR) -eq 4 -a $(KERNEL_VERSION_MINOR) -ge 12 \) && echo y)
endif
ifneq ($(findstring -rc,$(KERNEL_HEADER_VERSION)),)
KERNEL_HEADER_NEEDS_GIT_URL := $(call ptx/force-sh, test $(KERNEL_HEADER_VERSION_MAJOR) -ge 5 -o \( $(KERNEL_HEADER_VERSION_MAJOR) -eq 4 -a $(KERNEL_HEADER_VERSION_MINOR) -ge 12 \) && echo y)
endif

KERNEL_HEADERS_DIR	:= $(PTXDIST_SYSROOT_TARGET)/kernel-headers
KERNEL_HEADERS_INCLUDE_DIR := $(KERNEL_HEADERS_DIR)/include

kernel/url = \
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).x/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).x/testing/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).x/testing/v$(call kernel-major,$(1)).$(call kernel-minor,$(1))/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).x/longterm/v$(call kernel-major,$(1)).$(call kernel-minor,$(1))/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \
	\
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).$(call kernel-minor,$(1))/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).$(call kernel-minor,$(1))/testing/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).$(call kernel-minor,$(1))/testing/v$(call kernel-major,$(1)).$(call kernel-minor,$(1)).$(call kernel-micro,$(1))/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \
	$(call ptx/mirror, KERNEL, kernel/v$(call kernel-major,$(1)).$(call kernel-minor,$(1))/longterm/v$(call kernel-major,$(1)).$(call kernel-minor,$(1)).$(call kernel-micro,$(1))/linux-$($(1)_VERSION).$($(1)_SUFFIX)) \

kernel-url = \
	$(call kernel/url,$(strip $(1)))

kernel/opts = \
	$(PARALLELMFLAGS) \
	V=$(PTXDIST_VERBOSE) \
	HOSTCC=$(HOSTCC) \
	ARCH=$(GENERIC_KERNEL_ARCH) \
	CROSS_COMPILE=$(COMPILER_PREFIX) \
	DEPMOD=$(PTXDIST_SYSROOT_HOST)/sbin/depmod \
	\
	INSTALL_MOD_PATH=$($(1)_PKGDIR) \
	PTX_KERNEL_DIR=$($(1)_DIR)

kernel-opts = \
	$(call kernel/opts,$(strip $(1)))

#
# Blacklist for all low-level code, e.g. kernel and bootloaders
#
PTXDIST_LOWLEVEL_WRAPPER_BLACKLIST := \
	TARGET_HARDEN_STACK \
	TARGET_HARDEN_STACKCLASH \
	TARGET_HARDEN_FORTIFY \
	TARGET_HARDEN_RELRO \
	TARGET_HARDEN_BINDNOW \
	TARGET_HARDEN_PIE \
	TARGET_HARDEN_GLIBCXX_ASSERTIONS \
	TARGET_DEBUG \
	TARGET_BUILD_ID

#
# handle special compiler
#
ifdef PTXCONF_KERNEL
    ifneq ($(PTXCONF_COMPILER_PREFIX),$(PTXCONF_COMPILER_PREFIX_KERNEL))
        ifeq ($(wildcard selected_toolchain_kernel/$(PTXCONF_COMPILER_PREFIX_KERNEL)gcc),)
            $(warning *** no 'selected_toolchain_kernel' link found. Please create a link)
            $(warning *** 'selected_toolchain_kernel' to the bin directory of your)
            $(warning '$(PTXCONF_COMPILER_PREFIX_KERNEL)' toolchain)
            $(error )
        endif
        KERNEL_TOOLCHAIN_LINK := $(PTXDIST_WORKSPACE)/selected_toolchain_kernel/
    endif
endif

KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_LINK)$(PTXCONF_COMPILER_PREFIX_KERNEL)

# vim: syntax=make
