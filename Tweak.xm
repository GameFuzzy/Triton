//TO DO:
//1. Make newHUD actually show.
//2. Make muteButton work instead of crashing the springboard.
//3. Remove the bug that makes the volume slider appear as just a circle everytime it's opened.

static BOOL Enabled = YES;
static BOOL darkModeEnabled = NO;
CFStringRef tritonPrefsKey = CFSTR("com.zen.tritonprefs");
static CFStringRef settingsChangedNotification = CFSTR("com.zen.tritonprefs/settingschanged");
static CFStringRef darkModeKey = CFSTR("darkMode");
static CFStringRef EnabledKey = CFSTR("Enabled");
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MPVolumeView.h>
#import "Tweak.h"

#define imgPath @"/Library/PreferenceBundles/TritonPrefs.bundle/volume.png"
#define imgPathMute @"/Library/PreferenceBundles/TritonPrefs.bundle/mute.png"
#define imgPathNotMute @"/Library/PreferenceBundles/TritonPrefs.bundle/notmute.png"

#define imgPathDark @"/Library/PreferenceBundles/TritonPrefs.bundle/volumeDark.png"
#define imgPathMuteDark @"/Library/PreferenceBundles/TritonPrefs.bundle/muteDark.png"
#define imgPathNotMuteDark @"/Library/PreferenceBundles/TritonPrefs.bundle/notmuteDark.png"

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

@interface MPVolumeSlider : UISlider
-(void)setUserInteractionEnabled:(BOOL)arg1;
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

@interface SBMediaController : NSObject
+(id)sharedInstance;
-(BOOL)isRingerMuted;
-(void)setRingerMuted:(BOOL)arg1;
@end

MPVolumeSlider *newHUD = nil;
AVBackdropView *backdrop = nil;
AVBackdropView *backdropMute = nil;
UIView *placeholder = nil;
UIImageView *image;
UIImageView *imgViewMute;
UIImageView *imgViewVolume;
SBHUDWindow *HUDWindow;
BOOL ringerMuted;
UIButton *muteButton;
BOOL ringerShouldBeMuted;

@implementation Triton
- (void)setMuted1:(BOOL)shouldBe{[[%c(SBMediaController) sharedInstance] setRingerMuted:shouldBe];
}
- (void)setMuted{[self setMuted1:ringerShouldBeMuted];}

- (void)Test{}
@end

%hook SBHUDWindow

-(id)initWithScreen:(id)arg1 debugName:(id)arg2{
  HUDWindow = %orig;
  return HUDWindow;
}
%end

%hook SBHUDController
-(void)_orderWindowOut:(id)arg1{
  if(Enabled)
  {
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{backdropMute.alpha = 0;} completion:nil];

  [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{backdrop.alpha = 0;} completion:nil];
}
  %orig;
}
-(void)presentHUDView:(UIView*)HUDView autoDismissWithDelay:(CGFloat)arg2{
    %orig;
    if(Enabled)
{
    ringerMuted = [[%c(SBMediaController) sharedInstance] isRingerMuted];
    if(ringerMuted && darkModeEnabled){
      imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathMute];
    }
    else if (ringerMuted == NO && darkModeEnabled){
      imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathNotMute];
    }
    else if(ringerMuted && darkModeEnabled == NO)
    {
        imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathMuteDark];
    }
    else
    {
        imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathNotMuteDark];
    }
    if(darkModeEnabled){
          //[newHUD setMaximumValueImage:[UIImage imageWithContentsOfFile:imgPath]];
          imgViewVolume.image = [UIImage imageWithContentsOfFile:imgPath];
    }
    else{
    //[newHUD setMaximumValueImage:[UIImage imageWithContentsOfFile:imgPathDark]];
              imgViewVolume.image = [UIImage imageWithContentsOfFile:imgPathDark];
}

    if(ringerMuted){
      ringerShouldBeMuted = NO;
    }
    else{
      ringerShouldBeMuted = YES;
    }

    HUDView.hidden = YES;
    CGRect bounds;
    CGRect bounds1;
    bounds.size.width = 47;
    bounds.size.height = 200;
    bounds.origin.x = ([[UIScreen mainScreen] bounds].size.width) - 60;
    bounds.origin.y = 200;
    bounds1.size.height = 47;
    bounds1.size.width = 47;
    bounds1.origin.x = bounds.origin.x;
    bounds1.origin.y += (bounds.origin.y) + 215;
    if(newHUD == nil) {
      /*muteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      [muteButton setBackgroundColor:[UIColor redColor]];
      [muteButton addTarget:self
                 action:@selector(setMuted:)
       forControlEvents:UIControlEventTouchUpInside];
      muteButton.frame = bounds1;
*/
    newHUD = [[MPVolumeSlider alloc] initWithFrame:bounds];
      [newHUD setBackgroundColor:[UIColor clearColor]];
      [newHUD setUserInteractionEnabled:YES];
      [newHUD setAlpha:1];
    double rads = 3 * M_PI / 2;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rads);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0,17.5);
    newHUD.transform = CGAffineTransformConcat(translate, rotate);
    imgViewVolume = [[UIImageView alloc] initWithFrame:bounds1];
    CGAffineTransform scale1 = CGAffineTransformMakeScale(0.5,0.5);
    CGAffineTransform translate1 = CGAffineTransformMakeTranslation(0,0);
    imgViewVolume.transform = CGAffineTransformConcat(scale1, translate1);
    imgViewMute = [[UIImageView alloc] initWithFrame:bounds1];
    imgViewMute.transform = CGAffineTransformMakeScale(0.5,0.5);
    backdrop = [[AVBackdropView alloc] initWithFrame:bounds];
    backdropMute = [[AVBackdropView alloc] initWithFrame:bounds1];
    bounds.size.width = 35;
    bounds.origin.y = 0;
    backdrop.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    backdropMute.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    placeholder = [[UIView alloc] initWithFrame:bounds];
    [placeholder.widthAnchor constraintEqualToConstant:35].active = true;
    }

    bounds.origin.x = 40;
    bounds.size.width = 100;
    bounds.size.height = 47;

        [HUDWindow addSubview:backdrop];
        [HUDWindow addSubview:backdropMute];
        [newHUD.widthAnchor constraintEqualToConstant:100].active = true;
        [backdrop.contentView addArrangedSubview:newHUD];
        [backdrop.contentView addArrangedSubview:imgViewVolume];
        [backdrop.contentView addArrangedSubview:placeholder];
        [backdropMute.contentView addArrangedSubview:imgViewMute];
        //[backdropMute.contentView addArrangedSubview:muteButton];
        [newHUD setBounds:bounds];

  [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{backdrop.alpha = 1;} completion:nil];
  [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{backdropMute.alpha = 1;} completion:nil];
}
}

%end

%hook SBVolumeHUDView
  -(id)setProgress:(float)volume{
    [newHUD setValue:volume animated:true];
    return %orig;
  }
%end

/*%hook AVVolumeSlider
-(CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
  CGRect newbounds = %orig;
  newbounds.origin.y += 500.5;
  newbounds.origin.x += 887.5;
  newbounds.size.width = 25;
  newbounds.size.height = 25;
  return newbounds;
}


%end
*/
static void loadPrefs() {
  if (CFBridgingRelease(CFPreferencesCopyAppValue(darkModeKey, tritonPrefsKey))) {
             darkModeEnabled = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(darkModeKey, tritonPrefsKey)) boolValue];     }
             if (CFBridgingRelease(CFPreferencesCopyAppValue(EnabledKey, tritonPrefsKey))) {
               Enabled = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(EnabledKey, tritonPrefsKey)) boolValue];   }
}
%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, settingsChangedNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
    }
