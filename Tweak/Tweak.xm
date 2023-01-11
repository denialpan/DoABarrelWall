#import "DoABarrelWall.h"

@interface CSCoverSheetViewController : UIViewController

@end

@interface SBDashBoardViewController : UIViewController

@end

@interface SBIconController : UIViewController
- (void)updateWallpaper;
@end

@interface DNDState : UIViewController

@end

@interface SBLockScreenManager

@end

//big thanks to gc giving the best suggestion to optimize my tweak before release by caching images

%group lockscreenWallpaper13

//because CSCoverSheetViewController is technically the notification center
	%hook CSCoverSheetViewController

		- (void)viewDidLoad {

			%orig;

			/* dim and blur superview for when dim on dnd is enabled.
			   Because the CSCoverSheetViewController isn't affected by the system blur, this is a cheap way to simulate it
			 */
			dimBlurViewLS = [[UIView alloc] initWithFrame:[[self view] bounds]];
			[dimBlurViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			if (![dimBlurViewLS isDescendantOfView:[self view]]) [[self view] insertSubview:dimBlurViewLS atIndex:1];
			// blur
			blurLS = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			blurViewLS = [[UIVisualEffectView alloc] initWithEffect:blurLS];
			[blurViewLS setFrame:[dimBlurViewLS bounds]];
			[blurViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[blurViewLS setClipsToBounds:YES];
			[blurViewLS setAlpha:0.9];
			if (![blurViewLS isDescendantOfView:dimBlurViewLS]) [dimBlurViewLS addSubview:blurViewLS];
			// dim
			dimViewLS = [[UIView alloc] initWithFrame:[[self view] bounds]];
			[dimViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[dimViewLS setBackgroundColor:[UIColor blackColor]];
			[dimViewLS setAlpha:0.7];
			if (![dimViewLS isDescendantOfView:dimBlurViewLS]) [dimBlurViewLS addSubview:dimViewLS];
			//gonna be honest everything above I ctrl c ctrl v directly from Litten's github because I'm too lazy to do it myself lol
			//but essentially it's dim and blur subviews put into one big view, or at least i think so

			//set image view to the dimensions of the entire phone screen
			wallpaperImageViewLS = [[UIImageView alloc] initWithFrame:[[self view] bounds]];

			//set properties so that the image isn't distorted when filling the entire view
			[wallpaperImageViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[wallpaperImageViewLS setContentMode:UIViewContentModeScaleAspectFill];
			[wallpaperImageViewLS setClipsToBounds:YES];

			//add the view to the actual screen
			[[self view] insertSubview:wallpaperImageViewLS atIndex:0];



		}

		//this method handles when the notification center is invoked on the homescreen,
		//because this view CSCoverSheetViewController is shown for both the lockscreen and notification center
		- (void)viewWillAppear:(BOOL)animated {

			%orig;

			//this avoids the same wallpaper being displayed twice
			while ([previousLSVariable isEqualToString:variableLSName]) {

				//if the previous image variable is the same as the current chosen one, pick another random one until it isn't
				variableLSName = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];

			}

			//how caching images is implemented
			if (![cacheImageList objectForKey:variableLSName]) {

				//if dctionary doesnt contain image with appropriate keyword, cache image for the first time
				UIImage *cacheImage = [GcImagePickerUtils imageFromDefaults:@"com.denial.doabarrelwallprefs" withKey:variableLSName];

				if (!(cacheImage == nil)) {	//if the cache image has an image linked to it

					[wallpaperImageViewLS setImage:cacheImage];
					[cacheImageList setObject:cacheImage forKey:variableLSName];

				} else { //if it doesn't, set image view to nothing

					[wallpaperImageViewLS setImage:nil];

				}

			} else {

				//if a cache image already exists, then call this instead of having to use the library
				[wallpaperImageViewLS setImage:[cacheImageList objectForKey:variableLSName]];

			}

			//if the option to sync the homescreen wallpaper with the lockscreen is active
			//set this boolean to true, will be later handled to false when homescreen is in view
			if (syncBothScreens) {

				cameFromLockscreen = TRUE;

			}

			//set this variable to what the current image variable so the same image doesn't show up twice
			previousLSVariable = variableLSName;

		}

	%end

%end

%group lockscreenWallpaper12 // ios 12 support

//because SBDashBoardViewController is technically the notification center
	%hook SBDashBoardViewController

		- (void)viewDidLoad {

			%orig;

			/* dim and blur superview for when dim on dnd is enabled.
			   Because the CSCoverSheetViewController isn't affected by the system blur, this is a cheap way to simulate it
			 */
			dimBlurViewLS = [[UIView alloc] initWithFrame:[[self view] bounds]];
			[dimBlurViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			if (![dimBlurViewLS isDescendantOfView:[self view]]) [[self view] insertSubview:dimBlurViewLS atIndex:1];
			// blur
			blurLS = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			blurViewLS = [[UIVisualEffectView alloc] initWithEffect:blurLS];
			[blurViewLS setFrame:[dimBlurViewLS bounds]];
			[blurViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[blurViewLS setClipsToBounds:YES];
			[blurViewLS setAlpha:0.9];
			if (![blurViewLS isDescendantOfView:dimBlurViewLS]) [dimBlurViewLS addSubview:blurViewLS];
			// dim
			dimViewLS = [[UIView alloc] initWithFrame:[[self view] bounds]];
			[dimViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[dimViewLS setBackgroundColor:[UIColor blackColor]];
			[dimViewLS setAlpha:0.7];
			if (![dimViewLS isDescendantOfView:dimBlurViewLS]) [dimBlurViewLS addSubview:dimViewLS];
			//gonna be honest everything above I ctrl c ctrl v directly from Litten's github because I'm too lazy to do it myself lol
			//but essentially it's dim and blur subviews put into one big view, or at least i think so

			//set image view to the dimensions of the entire phone screen
			wallpaperImageViewLS = [[UIImageView alloc] initWithFrame:[[self view] bounds]];

			//set properties so that the image isn't distorted when filling the entire view
			[wallpaperImageViewLS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[wallpaperImageViewLS setContentMode:UIViewContentModeScaleAspectFill];
			[wallpaperImageViewLS setClipsToBounds:YES];

			//add the view to the actual screen
			[[self view] insertSubview:wallpaperImageViewLS atIndex:0];

		}

		//this method handles when the notification center is invoked on the homescreen,
		//because this view SBDashBoardViewController is shown for both the lockscreen and notification center
		- (void)viewWillAppear:(BOOL)animated {

			%orig;

			//this avoids the same wallpaper being displayed twice
			while ([previousLSVariable isEqualToString:variableLSName]) {

				//if the previous image variable is the same as the current chosen one, pick another random one until it isn't
				variableLSName = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];

			}

			//how caching images is implemented
			if (![cacheImageList objectForKey:variableLSName]) {

				//if dictionary doesnt contain image with appropriate keyword, cache image for the first time
				UIImage *cacheImage = [GcImagePickerUtils imageFromDefaults:@"com.denial.doabarrelwallprefs" withKey:variableLSName];

				if (!(cacheImage == nil)) {	//if the cache image has an image linked to it

					[wallpaperImageViewLS setImage:cacheImage];
					[cacheImageList setObject:cacheImage forKey:variableLSName];

				} else { //if it doesn't, set image view to nothing

					[wallpaperImageViewLS setImage:nil];

				}

			} else {

				//if a cache image already exists, then call this instead of having to use the library
				[wallpaperImageViewLS setImage:[cacheImageList objectForKey:variableLSName]];

			}

			//if the option to sync the homescreen wallpaper with the lockscreen is active
			//set this boolean to true, will be later handled to false when homescreen is in view
			if (syncBothScreens) {

				cameFromLockscreen = TRUE;

			}

			//set this variable to what the current image variable so the same image doesn't show up twice
			previousLSVariable = variableLSName;

		}

	%end

%end

//this group is for the lockscreen section
%group lockscreenWallpaperCompletion

	/*Initially, I had the hook to be whenever the power button was pressed (which was meant to simulate when the phone was put to sleep).
	  However, this was terrible, as it performed extraneous actions in events that I didn't want it to, such as turning the phone back on..
	  Thanks Litten for providing a better hook that detects when the phone is going into a sleeping state, not a repeated button press.*/
	%hook SBLockScreenManager

		- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 completion:(id)arg3 {

			%orig;

			isDeviceLocked = TRUE;

			while ([previousLSVariable isEqualToString:variableLSName]) {

				variableLSName = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];

			}

			if (![cacheImageList objectForKey:variableLSName]) {

				UIImage *cacheImage = [GcImagePickerUtils imageFromDefaults:@"com.denial.doabarrelwallprefs" withKey:variableLSName];

				if (!(cacheImage == nil)) {

					[wallpaperImageViewLS setImage:cacheImage];
					[cacheImageList setObject:cacheImage forKey:variableLSName];

				} else {

					[wallpaperImageViewLS setImage:nil];

				}

			} else {

				[wallpaperImageViewLS setImage:[cacheImageList objectForKey:variableLSName]];

			}

			if (syncBothScreens) {

				cameFromLockscreen = TRUE;

			}

			previousLSVariable = variableLSName;

		}

	%end

	//Thank you Litten for explaining how notifications and observers work, extremely big help here

	//force the dnd state to be detected immediately after respring
	%hook SpringBoard

		//after respring is finished
		- (void)applicationDidFinishLaunching:(id)arg1 {

			%orig;

			//send notification under the name "getDNDState" to be later catched by an observer
			[[NSNotificationCenter defaultCenter] postNotificationName:@"getDNDState" object:nil];

		}

	%end

	//detect when Do Not Disturb is active
	//thank you Arya_06 for pointing this small setting out, never knew that this dimming option existed natively for normal homescreen
	%hook DNDState

		- (id)initWithCoder:(id)arg1 {

			/*as how Litten put it: removeObserver removes all observers, also the ones from other tweaks, so be careful when to use it*/
			[[NSNotificationCenter defaultCenter] removeObserver:self];

			//catch the notification titled "getDNDState" and run the isActive method
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isActive) name:@"getDNDState" object:nil];

			return %orig;

		}

		//because this method isn't run immediately after respring, the state of DND isn't refreshed and sometimes the dnd blur view  will still exist
		//the notification observer explanation above is essential to prevent this issue from occurring.
	 	- (BOOL) isActive {

	 		isDNDActive = %orig;

	 		if (isDNDActive && dimEnabled) {
	 			dispatch_async(dispatch_get_main_queue(), ^{

					//show dim blur view if dnd is active
	 				[dimBlurViewLS setHidden:NO];
	 			});
	 		} else {
	 			dispatch_async(dispatch_get_main_queue(), ^{

					//hide dim blur view if dnd is active
	 				[dimBlurViewLS setHidden:YES];
	 			});
	 		}

	 		return isDNDActive;
	 	}

	%end

%end //end lockscreen section

//this group is for the homescreen section
//there will be less comments, because it does the same thing above, just for the homescreen view
%group homescreenWallpaper

	//view that exists on the homescreen
	%hook SBIconController

 		- (void)viewDidLoad {

			%orig;

 			wallpaperImageViewHS = [[UIImageView alloc] initWithFrame:[[self view] bounds]];

			wallpaperImageViewHS.bounds = CGRectInset(wallpaperImageViewHS.frame, -50, -50);
 			[wallpaperImageViewHS setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		 	[wallpaperImageViewHS setContentMode:UIViewContentModeScaleAspectFill];
		 	[wallpaperImageViewHS setClipsToBounds:YES];

 			[[self view] insertSubview:wallpaperImageViewHS atIndex:0];

 		}

		//this method handles when the homescreen is put back into view, mainly after the notification center is lifted up
		- (void)viewWillAppear:(BOOL)animated {

			%orig;

			[self updateWallpaper];

		}

		//i hate ios 12, i almost died doing this ~Litten
		- (id)contentView {

			if (!SYSTEM_VERSION_LESS_THAN(@"13")) return %orig;
			[self updateWallpaper];

			return %orig;

		}

		%new
		- (void)updateWallpaper {

			//if the homescreen is viewed for the first time after the lockscreen or notification center, set image to what the lockscreen was
			if (cameFromLockscreen && syncBothScreens) {

				if (!SYSTEM_VERSION_LESS_THAN(@"13"))
					[wallpaperImageViewHS setImage:[cacheImageList objectForKey:variableLSName]];
				else
					[UIView transitionWithView:wallpaperImageViewHS duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
						[wallpaperImageViewHS setImage:[cacheImageList objectForKey:variableLSName]];
					} completion:nil];

				//set to false to ensure that if the user left the homescreen
				//but came back to it without unlocking the device, to not use the lockscreen or notification center image
				cameFromLockscreen = FALSE;

			} else {

				//new thing to disable wallpaper change when leaving apps (however still change wallpaper normally if unlocking device for the first time)
				if (isDeviceLocked && disableChangeOnAppExit) {

					while ([previousHSVariable isEqualToString:variableHSName]) {

						variableHSName = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];
					}

					if (![cacheImageList objectForKey:variableHSName]) {

						UIImage *cacheImage = [GcImagePickerUtils imageFromDefaults:@"com.denial.doabarrelwallprefs" withKey:variableHSName];
						if (!(cacheImage == nil)) {

							if (!SYSTEM_VERSION_LESS_THAN(@"13"))
								[wallpaperImageViewHS setImage:cacheImage];
							else
								[UIView transitionWithView:wallpaperImageViewHS duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
									[wallpaperImageViewHS setImage:cacheImage];
								} completion:nil];
							[cacheImageList setObject:cacheImage forKey:variableHSName];

						} else {

							[wallpaperImageViewHS setImage:nil];

						}

					} else {

						if (!SYSTEM_VERSION_LESS_THAN(@"13"))
							[wallpaperImageViewHS setImage:[cacheImageList objectForKey:variableHSName]];
						else
							[UIView transitionWithView:wallpaperImageViewHS duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
								[wallpaperImageViewHS setImage:[cacheImageList objectForKey:variableHSName]];
							} completion:nil];

					}

					previousHSVariable = variableHSName;
					isDeviceLocked = FALSE;

				} else if (!disableChangeOnAppExit) { //if the above doesn't happen, continue as normal

					while ([previousHSVariable isEqualToString:variableHSName]) {

						variableHSName = [imageVariableList objectAtIndex:arc4random_uniform([imageVariableList count])];
					}

					if (![cacheImageList objectForKey:variableHSName]) {

						UIImage *cacheImage = [GcImagePickerUtils imageFromDefaults:@"com.denial.doabarrelwallprefs" withKey:variableHSName];
						if (!(cacheImage == nil)) {

							[wallpaperImageViewHS setImage:cacheImage];
							[cacheImageList setObject:cacheImage forKey:variableHSName];

						} else {

							[wallpaperImageViewHS setImage:nil];

						}

					} else {

						[wallpaperImageViewHS setImage:[cacheImageList objectForKey:variableHSName]];

					}

				previousHSVariable = variableHSName;

				}

			}

		}

 	%end

%end //end homescreen section

//this constructor is run only ONCE at respring
%ctor {

	//retrieve preferences from /var/mobile/Library/Preferences/
	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.denial.doabarrelwallprefs"];

	//get values from the list
	[preferences registerBool:&lockscreenEnabled default:NO forKey:@"lockscreenEnabled"];
	[preferences registerBool:&homescreenEnabled default:NO forKey:@"homescreenEnabled"];
	[preferences registerBool:&dimEnabled default:NO forKey:@"dimEnabled"];
	[preferences registerBool:&syncBothScreens default:NO forKey:@"syncBothScreens"];
	[preferences registerBool:&disableChangeOnAppExit default:NO forKey:@"disableChangeOnAppExit"];

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

			isDeviceLocked = TRUE;

		}

	}

	if (lockscreenEnabled) {

		//initialize lockscreen section
		if (!SYSTEM_VERSION_LESS_THAN(@"13")) %init(lockscreenWallpaper13);
		else if (SYSTEM_VERSION_LESS_THAN(@"13")) %init(lockscreenWallpaper12);
		%init(lockscreenWallpaperCompletion);

	}

	if (homescreenEnabled) {

		//initialize homescreen section
		%init(homescreenWallpaper);

	}
	return;

}