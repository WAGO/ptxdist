# -*-makefile-*-
#
# Copyright (C) 2002, 2003 by Pengutronix e.K., Hildesheim, Germany
#               2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#           (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ROOTFS) += rootfs

# dummy to make ipkg happy
ROOTFS_VERSION	:= 1.0.0
ROOTFS_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

ROOTFS_STAMP := $(call remove_quotes, \
	$(PTXCONF_PROJECT) \
	$(PTXCONF_PROJECT_VERSION) \
	$(PTXCONF_PLATFORM) \
	$(PTXCONF_PLATFORM_VERSION) \
	$(PTXDIST_VERSION_YEAR) \
	$(PTXDIST_VERSION_MONTH) \
	$(PTXDIST_VERSION_BUGFIX) \
	$(PTXDIST_VERSION_SCM) \
	$(PTXCONF_PROJECT_VENDOR) \
	)

# install new /etc/issue if versions change
$(call ptx/cfghash, ROOTFS, $(ROOTFS_STAMP))

$(STATEDIR)/rootfs.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  rootfs)
	@$(call install_fixup, rootfs,PRIORITY,optional)
	@$(call install_fixup, rootfs,SECTION,base)
	@$(call install_fixup, rootfs,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, rootfs,DESCRIPTION, "Filesystem Hierarchy Standard")

#	#
#	# install directories in rootfs
#	#
ifdef PTXCONF_ROOTFS_DEV
	@$(call install_copy, rootfs, 0, 0, 0755, /dev)
endif
ifdef PTXCONF_ROOTFS_DEV_INITIAL
	@$(call install_node, rootfs, 0, 0, 0666, c, 1, 3, /dev/null)
	@$(call install_node, rootfs, 0, 0, 0666, c, 1, 5, /dev/zero)
	@$(call install_node, rootfs, 0, 0, 0600, c, 5, 1, /dev/console)
endif
ifdef PTXCONF_ROOTFS_HOME
	@$(call install_copy, rootfs, 0, 0, 2775, /home)
endif
ifdef PTXCONF_ROOTFS_HOME_ROOT
	@$(call install_copy, rootfs, 0, 0, 0700, /root)
endif
ifdef PTXCONF_ROOTFS_MEDIA
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA1)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA1))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA2)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA2))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA3)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA3))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA4)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA4))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA5)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA5))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA6)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA6))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA7)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA7))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA8)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA8))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA9)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA9))
endif
ifneq ($(call remove_quotes,$(PTXCONF_ROOTFS_MEDIA10)),)
	@$(call install_copy, rootfs, 0, 0, 0777, /media/$(PTXCONF_ROOTFS_MEDIA10))
endif
endif
ifdef PTXCONF_ROOTFS_MNT
	@$(call install_copy, rootfs, 0, 0, 0755, /mnt)
endif
ifdef PTXCONF_ROOTFS_PROC
	@$(call install_copy, rootfs, 0, 0, 0555, /proc)
endif
ifdef PTXCONF_ROOTFS_RUN
	@$(call install_copy, rootfs, 0, 0, 0755, /run)
endif
ifdef PTXCONF_ROOTFS_SYS
	@$(call install_copy, rootfs, 0, 0, 0755, /sys)
endif
ifdef PTXCONF_ROOTFS_TMP
	@$(call install_copy, rootfs, 0, 0, 1777, /tmp)
endif
	@$(call install_copy, rootfs, 0, 0, 0755, /var)
ifdef PTXCONF_ROOTFS_VAR_LOG
	@$(call install_copy, rootfs, 0, 0, 0755, /var/log)
endif
ifdef PTXCONF_ROOTFS_VAR_RUN
	@$(call install_link, rootfs, ../run, /var/run)
endif
ifdef PTXCONF_ROOTFS_VAR_LOCK
	@$(call install_copy, rootfs, 0, 0, 0755, /var/lock)
endif
ifdef PTXCONF_ROOTFS_VAR_LIB
	@$(call install_copy, rootfs, 0, 0, 0755, /var/lib)
endif
ifdef PTXCONF_ROOTFS_VAR_CACHE
	@$(call install_copy, rootfs, 0, 0, 0755, /var/cache)
endif
ifdef PTXCONF_ROOTFS_VAR_SPOOL
	@$(call install_copy, rootfs, 0, 0, 0755, /var/spool)
endif
ifdef PTXCONF_ROOTFS_VAR_SPOOL_CRON
	@$(call install_copy, rootfs, 0, 0, 0755, /var/spool/cron)
endif
ifdef PTXCONF_ROOTFS_VAR_TMP
	@$(call install_copy, rootfs, 0, 0, 01777, /var/tmp)
endif
ifdef PTXCONF_ROOTFS_VAR_OVERLAYFS
	@$(call install_alternative, rootfs, 0, 0, 0644, \
		/usr/lib/systemd/system/run-varoverlayfs.mount)
	@$(call install_alternative, rootfs, 0, 0, 0755, \
		/usr/sbin/mount.varoverlayfs)
	@$(call install_alternative, rootfs, 0, 0, 0644, \
		/usr/lib/systemd/system/var.mount)
	@$(call install_link, rootfs, ../var.mount, \
		/usr/lib/systemd/system/local-fs.target.requires/var.mount)
endif

#	#
#	# install files in rootfs
#	#
ifdef PTXCONF_ROOTFS_PASSWD
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/passwd)
endif
ifdef PTXCONF_ROOTFS_SHADOW
	@$(call install_alternative, rootfs, 0, shadow, 0640, /etc/shadow)
endif
ifdef PTXCONF_ROOTFS_GROUP
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/group)
endif
ifdef PTXCONF_ROOTFS_GSHADOW
	@$(call install_alternative, rootfs, 0, shadow, 0640, /etc/gshadow)
endif
ifdef PTXCONF_ROOTFS_FSTAB
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/fstab)
	@$(call install_replace, rootfs, /etc/fstab, @VAR_OVERLAYFS@, \
		$(call ptx/ifdef,PTXCONF_ROOTFS_VAR_OVERLAYFS,#))
endif # PTXCONF_ROOTFS_FSTAB
ifdef PTXCONF_ROOTFS_MTAB_FILE
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/mtab)
endif
ifdef PTXCONF_ROOTFS_MTAB_LINK_MOUNTS
	@$(call install_link, rootfs, /proc/mounts, /etc/mtab)
endif
ifdef PTXCONF_ROOTFS_MTAB_LINK_SELF_MOUNTS
	@$(call install_link, rootfs, /proc/self/mounts, /etc/mtab)
endif
ifdef PTXCONF_ROOTFS_MTAB_LINK_VAR
	@$(call install_copy, rootfs, 0, 0, 0644, \
		$(PTXDIST_TOPDIR)/projectroot/etc/mtab, /var/tmp/mtab)
	@$(call install_link, rootfs, /var/tmp/mtab, /etc/mtab)
endif
ifdef PTXCONF_ROOTFS_HOSTNAME
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/hostname)
	@$(call install_replace, rootfs, /etc/hostname, \
		@HOSTNAME@, \
		$(call remove_quotes,$(PTXCONF_ROOTFS_ETC_HOSTNAME)))
endif
# must be after HOSTNAME!
ifdef PTXCONF_ROOTFS_ISSUE
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/issue)

	@$(call install_replace, rootfs, /etc/issue, \
		@PROJECT@, $(PTXCONF_PROJECT))
	@$(call install_replace, rootfs, /etc/issue, \
		@PRJVERSION@, $(PTXCONF_PROJECT_VERSION))
	@$(call install_replace, rootfs, /etc/issue, \
		@PLATFORM@, $(PTXCONF_PLATFORM))
	@$(call install_replace, rootfs, /etc/issue, \
		@PLATVERSION@, $(PTXCONF_PLATFORM_VERSION))
	@$(call install_replace, rootfs, /etc/issue, \
		@PTXDIST@, ptxdist)
	@$(call install_replace, rootfs, /etc/issue, \
		@VERSION@, $(PTXDIST_VERSION_YEAR))
	@$(call install_replace, rootfs, /etc/issue, \
		@PATCHLEVEL@, $(PTXDIST_VERSION_MONTH))
	@$(call install_replace, rootfs, /etc/issue, \
		@SUBLEVEL@, $(PTXDIST_VERSION_BUGFIX))
	@$(call install_replace, rootfs, /etc/issue, \
		@EXTRAVERSION@, $(PTXDIST_VERSION_SCM))
	@$(call install_replace, rootfs, /etc/issue, \
		@DATE@, $(shell date +%FT%T%z))
	@$(call install_replace, rootfs, /etc/issue, \
		@VENDOR@, $(PTXCONF_PROJECT_VENDOR))
	@$(call install_replace, rootfs, /etc/issue, \
		@HOSTNAME@, \
		$(call remove_quotes,$(PTXCONF_ROOTFS_ETC_HOSTNAME)))
	@$(call install_replace_figlet, rootfs, /etc/issue, \
		@FIGLET:VENDOR@, \
		`sed -r 's/ ?([\.:;,]) ?/ \1 /' <<< $(PTXCONF_PROJECT_VENDOR)`, \
		etcissue)
	@$(call install_replace_figlet, rootfs, /etc/issue, \
		@FIGLET:HOSTNAME@, \
		`sed -r 's/ ?([\.:;,]) ?/ \1 /' <<< $(PTXCONF_ROOTFS_ETC_HOSTNAME)`, \
		etcissue)
endif

ifdef PTXCONF_ROOTFS_HOSTS
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/hosts)
endif
ifdef PTXCONF_ROOTFS_MODPROBE_CONF
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/modprobe.conf)
endif
ifdef PTXCONF_ROOTFS_NSSWITCH_CONF
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/nsswitch.conf)
endif
ifdef PTXCONF_ROOTFS_PROFILE
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/profile)
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/profile.environment)
endif
ifdef PTXCONF_ROOTFS_PROTOCOLS
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/protocols)
endif
ifdef PTXCONF_ROOTFS_RESOLV_FILE
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/resolv.conf)
#	# replace either by PTXCONF_BOARDSETUP_GATEWAY or nothing if not defined
ifneq ($(PTXCONF_BOARDSETUP_GATEWAY),)
	@$(call install_replace, rootfs, /etc/resolv.conf, \
		@NAMESERVER_LINE@, \
		"nameserver $(PTXCONF_BOARDSETUP_GATEWAY)")
else
	@$(call install_replace, rootfs, /etc/resolv.conf, @NAMESERVER_LINE@, "")
endif
endif
ifdef PTXCONF_ROOTFS_RESOLV_LINK
	@$(call install_link, rootfs, /proc/net/pnp, /etc/resolv.conf)
endif
ifdef PTXCONF_ROOTFS_RESOLV_RUN
	@$(call install_link, rootfs, /run/resolv.conf, /etc/resolv.conf)
endif
ifdef PTXCONF_ROOTFS_RESOLV_SYSTEMD
	@$(call install_link, rootfs, /run/systemd/resolve/resolv.conf, /etc/resolv.conf)
endif
ifdef PTXCONF_ROOTFS_RESOLV_STATIC
	@$(call install_link, rootfs, /usr/lib/systemd/resolv.conf, /etc/resolv.conf)
endif
ifdef PTXCONF_ROOTFS_SERVICES
	@$(call install_alternative, rootfs, 0, 0, 0644, /etc/services)
endif

ifdef PTXCONF_ROOTFS_INIT_LINK
	@$(call install_link, rootfs, /sbin/init, /init)
endif
ifdef PTXCONF_ROOTFS_INIT_BIN
	@$(call install_alternative, rootfs, 0, 0, 0755, /init)
endif

	@$(call install_finish, rootfs)

	@echo "$(ROOTFS_STAMP)" > $(STATEDIR)/rootfs.stamp
	@$(call touch)

# vim: syntax=make
