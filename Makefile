export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:10.3

INSTALL_TARGET_PROCESSES = SpringBoard
SUBPROJECTS += Tweak Prefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk