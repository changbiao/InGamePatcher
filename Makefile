include theos/makefiles/common.mk

TWEAK_NAME = PROJECT_IGP
PROJECT_IGP_FILES = Tweak.xm SBTableAlert.m IGP_Config.m IGP_Cheater.m
PROJECT_IGP_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk
