/*
	initially, I thought that the inclusion of headers was pointless,
	as it just replaces the import line with the contents of the header, or at least that's how I think it works
	(https://stackoverflow.com/questions/439662/what-is-the-difference-between-import-and-include-in-objective-c)
	While it may seem to be a preference thing, I now prefer to use headers as a means to organize global variables later used in the Tweak.xm file
*/

#import <UIKit/UIKit.h>
#import <GcUniversal/GcImagePickerUtils.h>
#import <GcUniversal/GcImageUtils.h>
#import <Cephei/HBPreferences.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

HBPreferences* preferences;

BOOL lockscreenEnabled;                 //if lockscreen wallpaper is enabled
BOOL homescreenEnabled;                 //if homescreen wallpaper is enabled
BOOL syncBothScreens;                   //if sync both lockscreen and homescreen is enabled
BOOL dimEnabled;                        //if dim wallpapers on dnd is enabled
BOOL useStockViews;                     //if set system wallpaper is enabled
BOOL compatibilityModeEnabled;          //if tweak compatibility mode is enabled

BOOL cameFromLockscreen;                //if the user just came from the lockscreen
BOOL disableChangeOnAppExit;            //if user wants the wallpaper to only change by lockscreen
BOOL isDNDActive;                       //if the DND is active
BOOL isDeviceLocked;                    //gets state of device
UIColor *lockAvgColor;                  //average color of the lockscreen wallpaper

NSUInteger numberOfImagesToCache;       //thanks gc for clarifying that NSUInteger is a primitive type, not an object lol

UIImageView *wallpaperImageViewLS;      //image view used for the lockscreen
UIImageView *wallpaperImageViewHS;      //image view used for the homescreen
UIImage *image;                         //image that changes depending on the situation that is later used by the lockscreen and homescreen image views

UIView* dimBlurViewLS;                  //dimBlurViewLS is a combination of both the the dimViewLS and blurViewLS
UIView* dimViewLS;                      //dim blur
UIVisualEffectView* blurViewLS;         //blur view
UIBlurEffect* blurLS;                   //blur effect to be used on blurViewLS

NSString *previousLSVariable;           //string to save last used lockscreen image variable
NSString *previousHSVariable;           //string to save last used homescreen image variable

NSString *variableLSName;               //string to set current chosen lockscreen image variable
NSString *variableHSName;               //string to set current chosen homescreen image variable

NSArray *imageVariableList;             //array to hold all the available image variables to choose from
NSCache *cacheImageList;                //dictionary array to hold cache images
