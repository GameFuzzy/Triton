include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TritonPrefs
TritonPrefs_FILES = ZTPRootListController.m
TritonPrefs_INSTALL_PATH = /Library/PreferenceBundles
TritonPrefs_FRAMEWORKS = UIKit
TritonPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TritonPrefs.plist$(ECHO_END)
