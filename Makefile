export ARCHS = armv7 armv7s arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Triton
Triton_FILES = Tweak.xm
Triton_FRAMEWORKS = AVKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += tritonprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
