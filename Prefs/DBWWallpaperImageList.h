#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import "DBWRootListController.h"

@interface PSListController ()

    - (void)_moveSpecifierAtIndex:(unsigned long long)arg1 toIndex:(unsigned long long)arg2 animated:(bool)arg3;
    
@end

@interface PSEditableListController : PSListController

    //define methods
    - (void)editDoneTapped;
    - (BOOL)editable;
    - (BOOL)performDeletionActionForSpecifier:(PSSpecifier *)specifier;

@end

@interface DBWWallpaperImageList : PSEditableListController

    //define methods 
    @property(nonatomic, retain)UIButton* respringButton;
    - (NSString *)randomStringWithLength;
    - (void)loadSpecifierFromWallpaperImageList;
    - (PSSpecifier *)createImageSpecifier:(NSString *)linkToImage;
    - (void)saveImage:(PSSpecifier *)specifier;

@end