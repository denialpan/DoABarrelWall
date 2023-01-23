export ARCHS = arm64 arm64e
export TARGET := iphone:clang:11.2:11.2
export PREFIX = $(THEOS)/toolchain/Xcode.arm64eLegacy.xctoolchain/usr/bin/

INSTALL_TARGET_PROCESSES = SpringBoard
SUBPROJECTS += Tweak Prefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk