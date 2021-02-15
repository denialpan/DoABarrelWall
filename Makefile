export ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:10.3
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DoABarrelWall

DoABarrelWall_FILES = Tweak.xm
DoABarrelWall_CFLAGS = -fobjc-arc
DoABarrelWall_FRAMEWORKS = UIKit AudioToolbox
DoABarrelWall_EXTRA_FRAMEWORKS += Cephei 
DoABarrelWall_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += doabarrelwallprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
