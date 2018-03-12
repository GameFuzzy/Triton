//TO DO:
//Remove the bug that makes the volume slider appear as just a circle everytime it's opened.
//Create the preferences.
//Make the user able to pull the slider up and down using finger?

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

@interface SBMediaController : NSObject
+(id)sharedInstance;
-(BOOL)isRingerMuted;
@end

AVVolumeSlider *newHUD = nil;
AVBackdropView *backdrop = nil;
AVBackdropView *backdropMute = nil;
AVVolumeButtonControl *button = nil;
UIView *placeholder = nil;
UIImageView *image;
UIImageView *imgViewMute;
SBHUDWindow *HUDWindow;

%hook SBHUDWindow

-(id)initWithScreen:(id)arg1 debugName:(id)arg2{
  HUDWindow = %orig;
  return HUDWindow;
}
%end

%hook SBHUDController

-(void)_orderWindowOut:(id)arg1{
  [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{backdrop.alpha = 0;} completion:nil];
  %orig;
}

-(void)presentHUDView:(UIView*)HUDView autoDismissWithDelay:(CGFloat)arg2{
    %orig;

    BOOL ringerMuted = [[%c(SBMediaController) sharedInstance] isRingerMuted];
    if(ringerMuted){
      imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathMute];
    }
    else{
      imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathNotMute];
    }

    HUDView.hidden = true;
    CGRect bounds;
    CGRect bounds1;
    bounds.size.width = 47;
    bounds.size.height = 200;
    bounds.origin.x = ([[UIScreen mainScreen] bounds].size.width) - 60;;
    bounds.origin.y = 200;
    bounds1.size.height = 47;
    bounds1.size.width = 47;
    bounds1.origin.x = bounds.origin.x;
    bounds1.origin.y += (bounds.origin.y) + 215;

    if(newHUD == nil) {
    newHUD = [[AVVolumeSlider alloc] initWithFrame:bounds];
    [newHUD setMaximumValueImage:[UIImage imageWithContentsOfFile:imgPath]];
    double rads = 3 * M_PI / 2;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rads);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0,17.5);
    newHUD.transform = CGAffineTransformConcat(translate, rotate);
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
        [backdrop.contentView addArrangedSubview:placeholder];
        [backdropMute.contentView addArrangedSubview:imgViewMute];
        [newHUD setBounds:bounds];

  [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{backdrop.alpha = 1;} completion:nil];
}

%end

/*
%hook PTVolumeChangeNotifier
-(void)ringerSilentChanged{
  %orig;
  BOOL ringerMuted = [[%c(SBMediaController) sharedInstance] isRingerMuted];
  if(ringerMuted){
    imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathMute];
  }
  else{
    imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathNotMute];
  }
}
%end
*/

%hook SBVolumeHUDView
  -(id)setProgress:(float)volume{
    [newHUD setValue:volume animated:true];
    return %orig;
  }
%end

%hook AVVolumeSlider
-(CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
  CGRect newbounds = %orig;
  newbounds.origin.y += 500.5;
  newbounds.origin.x += 887.5;
  newbounds.size.width = 25;
  newbounds.size.height = 25;
  return newbounds;
}

%end
