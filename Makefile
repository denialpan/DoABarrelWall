export ARCHS = arm64 arm64e

export THEOS_PACKAGE_SCHEME = rootless

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
export TARGET = iphone:14.4:14.0
else
export TARGET := iphone:11.2:11.2
export PREFIX = $(THEOS)/toolchain/Xcode.arm64eLegacy.xctoolchain/usr/bin/
endif

INSTALL_TARGET_PROCESSES = SpringBoard
SUBPROJECTS += Tweak Prefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk