TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DoABarrelWallPrefs

DoABarrelWallPrefs_FILES = $(wildcard *.m)
DoABarrelWallPrefs_FRAMEWORKS = UIKit
DoABarrelWallPrefs_LIBRARIES = gcuniversal
DoABarrelWallPrefs_PRIVATE_FRAMEWORKS = Preferences
DoABarrelWallPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs 
DoABarrelWallPrefs_INSTALL_PATH = /Library/PreferenceBundles
ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN

include $(THEOS_MAKE_PATH)/bundle.mk
