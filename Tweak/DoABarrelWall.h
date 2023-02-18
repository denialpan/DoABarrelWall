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
BOOL compatibilityModeEnabled;          //if tweak compatibility mode is enabled

BOOL disableChangeOnAppExit;            //if user wants the wallpaper to only change by lockscreen
UIColor *lockAvgColor;                  //average color of the lockscreen wallpaper

NSUInteger numberOfImagesToCache;       //thanks gc for clarifying that NSUInteger is a primitive type, not an object lol

NSString *previousLSVariable;           //string to save last used lockscreen image variable
NSString *previousHSVariable;           //string to save last used homescreen image variable

NSString *variableLSName;               //string to set current chosen lockscreen image variable
NSString *variableHSName;               //string to set current chosen homescreen image variable

NSArray *imageVariableList;             //array to hold all the available image variables to choose from
NSCache *cacheImageList;                //dictionary array to hold cache images

NSString * const kPrefsIdentifier = @"com.denial.doabarrelwallprefs";