#import "DoABarrelWall.h"

@interface SBLockScreenManager
+ (id)sharedInstance;
- (void)wallpaperDidChangeForVariant:(NSInteger)arg0 ;
@end

@interface SBFWallpaperView : UIView
@property (assign,nonatomic) BOOL parallaxEnabled;
@property (retain, nonatomic) UIView *contentView;
-(void)setContentsRect:(struct CGRect )arg0 ;
-(id)blurredImage;
@end

@interface SBWallpaperEffectView : UIView
@property (retain, nonatomic) UIView /*<_SBFakeBlur>*/*blurView;
@end

@interface SBWallpaperViewController : UIViewController //SBWWallpaperViewController on iOS 15, as there is a new framework (SpringBoardWallpaper.framework), same thing though
@property (retain, nonatomic) SBFWallpaperView *lockscreenWallpaperView;
@property (retain, nonatomic) SBFWallpaperView *homescreenWallpaperView;
-(NSHashTable *)_observersForVariant:(NSInteger)arg0 ;
-(id)_blurViewsForVariant:(NSInteger)arg0 ;
@end

//https://headers.cynder.me/index.php?sdk=ios/15.4&fw=PrivateFrameworks/SpringBoard.framework&file=Headers/SBWallpaperController.h
@interface SBWallpaperController : NSObject {
	SBWallpaperViewController *_wallpaperViewController; //iOS 14+
}
+ (id)sharedInstance;

//iOS 13-
@property (retain, nonatomic) SBFWallpaperView *lockscreenWallpaperView;
@property (retain, nonatomic) SBFWallpaperView *homescreenWallpaperView;
-(NSHashTable *)_observersForVariant:(NSInteger)arg0 ;
-(id)_blurViewsForVariant:(NSInteger)arg0 ;
@end

@interface UIDeviceRGBColor : UIColor
@end

@interface _SBWFakeBlurView : UIView
@property (readonly, nonatomic) NSInteger variant;
-(NSInteger)effectiveStyle;
-(void)_setImage:(id)arg1 style:(long long)arg2 notify:(BOOL)arg3 ; //iOS 13-
@end

@interface _SBFakeBlurView : _SBWFakeBlurView
@end

@interface MTMaterialView : UIView
+(id)materialViewWithRecipe:(NSInteger)arg0 configuration:(NSInteger)arg1 ;
@end

//big thanks to gc giving the best suggestion to optimize my tweak before release by caching images

//this group is for setting the wallpapers using the system interface
%group systemWallpaper

	//enum for the wallpaper destination
	typedef NS_OPTIONS(NSInteger, WallpaperLocation) {
		kLockScreen = 1 << 0,
		kHomeScreen = 1 << 1
	};

	static void updateForImageLocation(UIImage *img, WallpaperLocation loc) {

		SBWallpaperController *wallpaperController = [objc_getClass("SBWallpaperController") sharedInstance];
		SBWallpaperViewController *responsible = SYSTEM_VERSION_LESS_THAN(@"14") ? wallpaperController : [wallpaperController valueForKey:@"_wallpaperViewController"];

		SBFWallpaperView *wallpaperView = (loc & kLockScreen) ? [responsible lockscreenWallpaperView] : [responsible homescreenWallpaperView];
		[wallpaperView setParallaxEnabled:NO];

		UIImageView *wpImageView = (UIImageView *)[wallpaperView contentView];
		if ([wpImageView isKindOfClass:[UIImageView class]]) {

			[wpImageView setBounds:[UIScreen mainScreen].bounds];
			[wpImageView setContentMode:UIViewContentModeScaleAspectFill];
			[wpImageView setImage:img];

		}

		NSHashTable *blurs = [responsible _blurViewsForVariant:loc-1];
		for (_SBWFakeBlurView *blur in blurs) {
			if ([blur isKindOfClass:objc_getClass("_SBFakeBlurView")] || [blur isKindOfClass:objc_getClass("_SBWFakeBlurView")]) {
				if ([blur effectiveStyle] == 0) {
					SBFWallpaperView *fakeWPView = (SBFWallpaperView *)[blur valueForKey:@"_wallpaperView"];
					[fakeWPView setParallaxEnabled:NO];
					[fakeWPView contentView].bounds = [UIScreen mainScreen].bounds;

					NSString *key = SYSTEM_VERSION_LESS_THAN(@"15") ? @"_imageView" : @"_providedImageView";

					UIImageView *fakeImageView = (UIImageView *)[blur valueForKey:key];
					[fakeImageView setContentMode:UIViewContentModeScaleAspectFill];
					[fakeImageView setImage:img];
				}
			}
		}

		if (compatibilityModeEnabled && loc & kLockScreen) {

			CGFloat r,g,b,a;
			[[img averageColor] getRed:&r green:&g blue:&b alpha:&a];

			//UIDeviceRGBColor is needed as the SB uses it and it would otherwise crash
			lockAvgColor = [[objc_getClass("UIDeviceRGBColor") alloc] initWithRed:r green:g blue:b alpha:a];
			//also, I guess one could add color caching here, but I don't want to right now

		}
	}

	static void updateWallpaperForLocation(WallpaperLocation location) {

		if (location & kLockScreen && !lockscreenEnabled) return;
		if (location & kHomeScreen && !homescreenEnabled) return;

		NSString * __strong *wpKey = (location & kLockScreen) ? &variableLSName : &variableHSName;
		NSString * __strong *lastWpKey = (location & kLockScreen) ? &previousLSVariable : &previousHSVariable;
		WallpaperLocation destination = (syncBothScreens) ? (kLockScreen | kHomeScreen) : location;

		while ([*lastWpKey isEqualToString:*wpKey])
			*wpKey = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];

		//load image if not in cache
		UIImage *newWallpaper;
		if (!(newWallpaper = [cacheImageList objectForKey:*wpKey])) {

			newWallpaper = [GcImagePickerUtils imageFromDefaults:@"com.denial.doabarrelwallprefs" withKey:*wpKey];

			if (!newWallpaper)
				return;

			[cacheImageList setObject:newWallpaper forKey:*wpKey];

		}

		//set the wallpaper
		dispatch_async(dispatch_get_main_queue(), ^{

			if (destination & kLockScreen)
				updateForImageLocation(newWallpaper, kLockScreen);

			if (destination & kHomeScreen)
				updateForImageLocation(newWallpaper, kHomeScreen);

			if (compatibilityModeEnabled) {

				[[objc_getClass("SBLockScreenManager") sharedInstance] wallpaperDidChangeForVariant:destination-1];
				CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.apple.springboard.wallpaperchanged"), NULL, NULL, 0);

			}

		});

		*lastWpKey = *wpKey;
		if (syncBothScreens) {
			(location & kLockScreen) ? variableHSName : variableLSName = *wpKey;
			(location & kLockScreen) ? previousHSVariable : previousLSVariable = *wpKey;
		}
	}

	//get update events for the NotifCenter - Lockscreen
	%hook NotifCenterController

		- (void)viewWillAppear:(BOOL)animated {

			%orig;

			updateWallpaperForLocation(kLockScreen);

		}

	%end

	//get update events on device lock - Lockscreen
	%hook SBLockScreenManager

		- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 completion:(id)arg3 {

			%orig;

			updateWallpaperForLocation(kLockScreen);

			if (disableChangeOnAppExit)
				updateWallpaperForLocation(kHomeScreen);

		}

		- (id)averageColorForCurrentWallpaper {

			return (compatibilityModeEnabled && lockAvgColor) ? lockAvgColor : %orig;

		}

	%end

	//get update events for the Homescreen
	%hook SBIconController

		//this method handles when the homescreen is put back into view, mainly after the notification center is lifted up
		- (void)viewWillAppear:(BOOL)animated {

			if (!disableChangeOnAppExit)
				updateWallpaperForLocation(kHomeScreen);

			%orig;

		}

		//i hate ios 12, i almost died doing this ~Litten
		- (id)contentView {

			if (SYSTEM_VERSION_LESS_THAN(@"13") && !disableChangeOnAppExit)
				updateWallpaperForLocation(kHomeScreen);

			return %orig;

		}

	%end

	//make sure we have 2 WPImageViews, as that makes it easier to set the wallpapers
	%hook WPController

		- (BOOL)variantsShareWallpaper {

			return NO;

		}

		- (void)_registerFakeBlurView:(_SBWFakeBlurView *)blur {
			%orig;


		}

	%end

	//fuck iOS 15
	%hook _SBWFakeBlurView

		- (void)layoutSubviews {

			%orig;

			if ([self variant] == 0)
				[[self valueForKey:@"_providedImageView"] setFrame:[UIScreen mainScreen].bounds];

		}

	%end

	%hook _SBFakeBlurView

		/*
			Half working fix for the CoverSheet sliding thingy.

			The idea is to hook the method where the image on the fake view is being set, and overwrite that one with our one, for the right variant.

			variant = 0 -> lockscreen
			variant = 1 -> homescreen
		*/
		-(void)_setImage:(id)arg0 style:(NSInteger)arg1 notify:(BOOL)arg2 {
			%orig;

			if (lockscreenEnabled && self.variant == 0) {
				NSLog(@"Changing fakeBlurView on the fly - %@", self);
				UIImage *img;
				if (!(img = [cacheImageList objectForKey:variableLSName])) {

					img = [GcImagePickerUtils imageFromDefaults:@"com.denial.doabarrelwallprefs" withKey:variableLSName];

					if (!img)
						return;

					[cacheImageList setObject:img forKey:variableLSName];

				}

				SBFWallpaperView *fakeWPView = (SBFWallpaperView *)[self valueForKey:@"_wallpaperView"];
				[fakeWPView setParallaxEnabled:NO];
				[fakeWPView contentView].bounds = [UIScreen mainScreen].bounds;

				NSString *key = SYSTEM_VERSION_LESS_THAN(@"15") ? @"_imageView" : @"_providedImageView";

				UIImageView *fakeImageView = (UIImageView *)[self valueForKey:key];
				[fakeImageView setContentMode:UIViewContentModeScaleAspectFill];
				[fakeImageView setImage:img];
			}
		}
	%end

	//fuck iOS 13
	%hook SBFolderIconImageView
		- (void)setBackgroundView:(UIView *)backgroundView {

			if (SYSTEM_VERSION_LESS_THAN(@"14")) {
				CGRect origFrame = backgroundView.frame;
				backgroundView = [objc_getClass("MTMaterialView") materialViewWithRecipe:1 configuration:1];
				backgroundView.frame = origFrame;
			}

			%orig(backgroundView);

		}
	%end

%end //end systemWallpaper section

//this constructor is run only ONCE at respring
%ctor {

	//retrieve preferences from /var/mobile/Library/Preferences/
	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.denial.doabarrelwallprefs"];

	//get values from the list
	[preferences registerBool:&lockscreenEnabled default:NO forKey:@"lockscreenEnabled"];
	[preferences registerBool:&homescreenEnabled default:NO forKey:@"homescreenEnabled"];
	[preferences registerBool:&syncBothScreens default:NO forKey:@"syncBothScreens"];
	[preferences registerBool:&disableChangeOnAppExit default:NO forKey:@"disableChangeOnAppExit"];
	[preferences registerBool:&compatibilityModeEnabled default:YES forKey:@"compatibilityModeEnabled"]; //mainly Jellyfish atm

	[preferences registerUnsignedInteger:&numberOfImagesToCache default:5 forKey:@"numberOfImagesToCache"];

	//if either one of the sections are enabled, then set these values, otherwise, dont bother to save on resources
	if (lockscreenEnabled || homescreenEnabled) {

		//create a copy of the values in the plist, this way we only read from an array without the risk of messing stuff up
		imageVariableList = [[preferences objectForKey:@"imageVariableList"] copy];

		if (!([imageVariableList count] < 2)) { //ensures that the user at least attempted to use two images

			//set a random image at the very beginning after respringing
			variableLSName = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];
			variableHSName = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];

			//set these variables to nothing on the first run to prevent infinite while loops
			previousLSVariable = @"";
			previousHSVariable = @"";

			//create/refresh cache dictionary
			cacheImageList = [[NSCache alloc] init];
			[cacheImageList setCountLimit:numberOfImagesToCache];


			[cacheImageList setEvictsObjectsWithDiscardedContent:YES]; //defaulted to no, but is not strictly enforced by implementation

		}

	} else {

		//if both sections are disabled, then we can just return and not do anything
		return;

	}

		//initialize system wallpaper section
		Class wpControllerClass = SYSTEM_VERSION_LESS_THAN(@"15") ? (SYSTEM_VERSION_LESS_THAN(@"14") ? objc_getClass("SBWallpaperController") : objc_getClass("SBWallpaperViewController")) : objc_getClass("SBWWallpaperViewController");
		%init(systemWallpaper, WPController = wpControllerClass);

}