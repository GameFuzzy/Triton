//TO DO:
//Remove the bug that makes the volume slider appear as just a circle everytime it's opened.
//Give the bounds different origins depending on scren size. Example project: https://github.com/runnersaw/MinimalHUD/blob/master/Tweak.xm

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
    //CGAffineTransform translate1 = CGAffineTransformMakeTranslation(315, 430);
    //CGAffineTransform resize = CGAffineTransformMakeScale(30,30);
    imgViewMute.transform = CGAffineTransformMakeScale(0.5,0.5);
    //imgViewMute.image = [UIImage imageWithContentsOfFile:imgPathMute];
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

  %orig;
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
