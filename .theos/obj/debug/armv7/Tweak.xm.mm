#line 1 "Tweak.xm"




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <AVKit/AVKit.h>
#define imgPath @"/Library/PreferenceBundles/TritonPrefs.bundle/volume.png"
#define imgPathMute @"/Library/PreferenceBundles/TritonPrefs.bundle/mute.png"
#define imgPathNotMute @"/Library/PreferenceBundles/TritonPrefs.bundle/notmute.png"

@interface AVVolumeSlider : UISlider
@property (nonatomic) bool collapsed;
@property (nonatomic) bool collapsedOrExcluded;
@property (nonatomic) float effectiveVolumeLimit;
@property (nonatomic) CGSize extrinsicContentSize;
@property (nonatomic) bool hasFulllScreenAppearance;
@property (nonatomic) bool included;
@property (nonatomic, assign) NSNumber *unclampedValue;
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@property (nonatomic) float value;

-(id)initWithFrame:(CGRect)arg1;
-(void)_setCornerRadius:(CGFloat)arg1;
+(id)alloc;
@end

@interface AVStackView : UIStackView
@end

@interface AVBackdropView : AVStackView
@property (nonatomic, assign) AVStackView *contentView;
@end

@interface AVVolumeButtonControl : UIControl
@property (nonatomic) CGRect frame;
-(void)_setContentImage:(id)image;
@end

@interface SBHUDWindow
-(void)addSubview:(UIView*)arg1;
-(void)_addSubview:(UIView*)arg1 positioned:(NSInteger)arg2 relativeTo:(id)arg3;
@end

@interface SBHUDView
@end

@interface MNRingerSwitchObserver : NSObject
+(id)sharedObserver;
@end

AVVolumeSlider *newHUD = nil;
AVBackdropView *backdrop = nil;
AVBackdropView *backdropMute = nil;
AVVolumeButtonControl *button = nil;
UIView *placeholder = nil;
UIImageView *image;
UIImageView *imgViewMute;
SBHUDWindow *HUDWindow;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class PTVolumeChangeNotifier; @class AVVolumeSlider; @class SBHUDController; @class SBVolumeHUDView; @class MNRingerSwitchObserver; @class SBHUDWindow; 
static SBHUDWindow* (*_logos_orig$_ungrouped$SBHUDWindow$initWithScreen$debugName$)(_LOGOS_SELF_TYPE_INIT SBHUDWindow*, SEL, id, id) _LOGOS_RETURN_RETAINED; static SBHUDWindow* _logos_method$_ungrouped$SBHUDWindow$initWithScreen$debugName$(_LOGOS_SELF_TYPE_INIT SBHUDWindow*, SEL, id, id) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$SBHUDController$presentHUDView$autoDismissWithDelay$)(_LOGOS_SELF_TYPE_NORMAL SBHUDController* _LOGOS_SELF_CONST, SEL, UIView*, CGFloat); static void _logos_method$_ungrouped$SBHUDController$presentHUDView$autoDismissWithDelay$(_LOGOS_SELF_TYPE_NORMAL SBHUDController* _LOGOS_SELF_CONST, SEL, UIView*, CGFloat); static id (*_logos_orig$_ungrouped$SBVolumeHUDView$setProgress$)(_LOGOS_SELF_TYPE_NORMAL SBVolumeHUDView* _LOGOS_SELF_CONST, SEL, float); static id _logos_method$_ungrouped$SBVolumeHUDView$setProgress$(_LOGOS_SELF_TYPE_NORMAL SBVolumeHUDView* _LOGOS_SELF_CONST, SEL, float); static CGRect (*_logos_orig$_ungrouped$AVVolumeSlider$maximumValueImageRectForBounds$)(_LOGOS_SELF_TYPE_NORMAL AVVolumeSlider* _LOGOS_SELF_CONST, SEL, CGRect); static CGRect _logos_method$_ungrouped$AVVolumeSlider$maximumValueImageRectForBounds$(_LOGOS_SELF_TYPE_NORMAL AVVolumeSlider* _LOGOS_SELF_CONST, SEL, CGRect); static void (*_logos_orig$_ungrouped$PTVolumeChangeNotifier$ringerSilentChanged)(_LOGOS_SELF_TYPE_NORMAL PTVolumeChangeNotifier* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$PTVolumeChangeNotifier$ringerSilentChanged(_LOGOS_SELF_TYPE_NORMAL PTVolumeChangeNotifier* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MNRingerSwitchObserver(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MNRingerSwitchObserver"); } return _klass; }
#line 62 "Tweak.xm"


static SBHUDWindow* _logos_method$_ungrouped$SBHUDWindow$initWithScreen$debugName$(_LOGOS_SELF_TYPE_INIT SBHUDWindow* __unused self, SEL __unused _cmd, id arg1, id arg2) _LOGOS_RETURN_RETAINED{
  HUDWindow = _logos_orig$_ungrouped$SBHUDWindow$initWithScreen$debugName$(self, _cmd, arg1, arg2);
  return HUDWindow;
}




static void _logos_method$_ungrouped$SBHUDController$presentHUDView$autoDismissWithDelay$(_LOGOS_SELF_TYPE_NORMAL SBHUDController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIView* HUDView, CGFloat arg2){
  
    _logos_orig$_ungrouped$SBHUDController$presentHUDView$autoDismissWithDelay$(self, _cmd, HUDView, arg2);
    HUDView.hidden = true;
    CGRect bounds;
    CGRect bounds1;
    bounds.size.width = 47;
    bounds.size.height = 200;
    bounds.origin.x = 500;
    bounds.origin.y = 0;
    bounds1.size.height = 47;
    bounds1.size.width = 47;
    bounds1.origin.y = 285;
    bounds1.origin.x += 315;
    bounds1.origin.y += 130;
    if(newHUD == nil) {
    newHUD = [[AVVolumeSlider alloc] initWithFrame:bounds];
    [newHUD setMaximumValueImage:[UIImage imageWithContentsOfFile:imgPath]];
    double rads = 3 * M_PI / 2;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rads);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0,17.5);
    newHUD.transform = CGAffineTransformConcat(translate, rotate);
    imgViewMute = [[UIImageView alloc] initWithFrame:bounds1];
    
    
    imgViewMute.transform = CGAffineTransformMakeScale(0.5,0.5);
    
    bounds.size.width = 47;
    bounds.origin.x = 315;
    bounds.origin.y = 200;
    backdrop = [[AVBackdropView alloc] initWithFrame:bounds];
    backdropMute = [[AVBackdropView alloc] initWithFrame:bounds1];
    bounds.size.width = 35;
    bounds.origin.y = 0;
placeholder = [[UIView alloc] initWithFrame:bounds];
[placeholder.widthAnchor constraintEqualToConstant:35].active = true;

    }

    bounds.origin.x = 40;
    bounds.origin.y = 0;
    bounds.size.width = 100;
    bounds.size.height = 47;

        [HUDWindow addSubview:backdrop];
        [HUDWindow addSubview:backdropMute];
        [newHUD.widthAnchor constraintEqualToConstant:100].active = true;
        [backdrop.contentView addArrangedSubview:newHUD];
        [backdrop.contentView addArrangedSubview:placeholder];
        [backdropMute.contentView addArrangedSubview:imgViewMute];
        [newHUD setBounds:bounds];

  _logos_orig$_ungrouped$SBHUDController$presentHUDView$autoDismissWithDelay$(self, _cmd, HUDView, arg2);
}




  static id _logos_method$_ungrouped$SBVolumeHUDView$setProgress$(_LOGOS_SELF_TYPE_NORMAL SBVolumeHUDView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, float volume){
    [newHUD setValue:volume animated:true];
    return _logos_orig$_ungrouped$SBVolumeHUDView$setProgress$(self, _cmd, volume);
  }



static CGRect _logos_method$_ungrouped$AVVolumeSlider$maximumValueImageRectForBounds$(_LOGOS_SELF_TYPE_NORMAL AVVolumeSlider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, CGRect bounds){
  CGRect newbounds = _logos_orig$_ungrouped$AVVolumeSlider$maximumValueImageRectForBounds$(self, _cmd, bounds);
  newbounds.origin.y += 500.5;
  newbounds.origin.x += 887.5;
  newbounds.size.width = 25;
  newbounds.size.height = 25;
  return newbounds;
}




BOOL silentEnabled = MSHookIvar<BOOL *>([_logos_static_class_lookup$MNRingerSwitchObserver() sharedObserver], "_ringerSwitchEnabled");
static void _logos_method$_ungrouped$PTVolumeChangeNotifier$ringerSilentChanged(_LOGOS_SELF_TYPE_NORMAL PTVolumeChangeNotifier* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
  _logos_orig$_ungrouped$PTVolumeChangeNotifier$ringerSilentChanged(self, _cmd);
  if(silentEnabled){
    imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathMute];
  }
  else{
    imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathNotMute];
  }
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBHUDWindow = objc_getClass("SBHUDWindow"); MSHookMessageEx(_logos_class$_ungrouped$SBHUDWindow, @selector(initWithScreen:debugName:), (IMP)&_logos_method$_ungrouped$SBHUDWindow$initWithScreen$debugName$, (IMP*)&_logos_orig$_ungrouped$SBHUDWindow$initWithScreen$debugName$);Class _logos_class$_ungrouped$SBHUDController = objc_getClass("SBHUDController"); MSHookMessageEx(_logos_class$_ungrouped$SBHUDController, @selector(presentHUDView:autoDismissWithDelay:), (IMP)&_logos_method$_ungrouped$SBHUDController$presentHUDView$autoDismissWithDelay$, (IMP*)&_logos_orig$_ungrouped$SBHUDController$presentHUDView$autoDismissWithDelay$);Class _logos_class$_ungrouped$SBVolumeHUDView = objc_getClass("SBVolumeHUDView"); MSHookMessageEx(_logos_class$_ungrouped$SBVolumeHUDView, @selector(setProgress:), (IMP)&_logos_method$_ungrouped$SBVolumeHUDView$setProgress$, (IMP*)&_logos_orig$_ungrouped$SBVolumeHUDView$setProgress$);Class _logos_class$_ungrouped$AVVolumeSlider = objc_getClass("AVVolumeSlider"); MSHookMessageEx(_logos_class$_ungrouped$AVVolumeSlider, @selector(maximumValueImageRectForBounds:), (IMP)&_logos_method$_ungrouped$AVVolumeSlider$maximumValueImageRectForBounds$, (IMP*)&_logos_orig$_ungrouped$AVVolumeSlider$maximumValueImageRectForBounds$);Class _logos_class$_ungrouped$PTVolumeChangeNotifier = objc_getClass("PTVolumeChangeNotifier"); MSHookMessageEx(_logos_class$_ungrouped$PTVolumeChangeNotifier, @selector(ringerSilentChanged), (IMP)&_logos_method$_ungrouped$PTVolumeChangeNotifier$ringerSilentChanged, (IMP*)&_logos_orig$_ungrouped$PTVolumeChangeNotifier$ringerSilentChanged);} }
#line 161 "Tweak.xm"
