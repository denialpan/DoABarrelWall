BUNDLE_NAME = DoABarrelWallPrefs
DoABarrelWallPrefs_FILES = $(wildcard *.m)
DoABarrelWallPrefs_LIBRARIES = gcuniversal
DoABarrelWallPrefs_PRIVATE_FRAMEWORKS = Preferences
DoABarrelWallPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
DoABarrelWallPrefs_INSTALL_PATH = /Library/PreferenceBundles
ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN

ifneq ($(THEOS_PACKAGE_SCHEME),rootless)
ADDITIONAL_CFLAGS += -D XINA_SUPPORT
endif

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk
