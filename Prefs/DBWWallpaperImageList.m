/*
	This was perhaps the most confusing part of this entire tweak. An editable preference list.

	The easiest way to picture this is that I imagine specifiers to be are XML <dicts>, similar to the .plists hardcoded in
	However, I believe that specifiers are temporary, therefore, they always have to be created repeatedly
	anytime that the page is loaded. In order for specifiers to be somewhat dynamically created but also saved
	is that information about each specifier needs to be written somewhere directly onto the device.

	Given how the specifiers that I create require information that links to images on the device, this is a
	piece of information that requires that I write to the device. Variable names are linked to images that
	are created by the library libGcUniversal under the same name as variable. This ensures that there are no
	other environment variable that can modify the linkage between the variable and the image file itself, so
	to speak. This was a problem that took me a while to solve, as the previous way I implemented the creation
	of variable names was by array indexes, which dynamically changed. This caused the variables to be linked to
	images that were created previously because the index of variable would move up one space. If you want to receive
	a more detailed explanation on what I mean, there is one provided below, hopefully it will make more sense.

	Big fat thanks to @AzzouDuGhetto, 99% of all the code here stems from his help, so I literally could not have made any of this without him taking time out of his day
	to explain the fundamentals of how this all works. Thank you so much.
*/

#import "DBWWallpaperImageList.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>
#import <spawn.h>
#import <AudioToolbox/AudioServices.h>

//preferences
HBPreferences *prefs;

//temporary copy of the array from the plist that we can modify without accessing the plist directly
NSMutableArray *imageVariableList;

//keep track of which physical files to remove when save button is performed
NSMutableArray *removeVariableList;

//just the alphanumeric characters used to generate the random variable image name
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation DBWWallpaperImageList

//also something essential
- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[self reload];

}

//also something essential, yep
- (void)viewDidLoad {

	[super viewDidLoad];
	[self loadSpecifierFromWallpaperImageList];
	[self reload];

}

//load specifiers from plist array written on the device
- (void)loadSpecifierFromWallpaperImageList {

	//This temporary array exists to copy the values in array that is written on the device
	//this allows us to modify it without messing things up
	[imageVariableList removeAllObjects];
	[removeVariableList removeAllObjects];
	imageVariableList = [[prefs objectForKey:@"imageVariableList"] mutableCopy];

	//if these arrays below return null, initialize them

	//this array is a copy of the array in the plist
	if (!(imageVariableList)) {
		imageVariableList = [[NSMutableArray alloc] init];
	}

	//this array holds the variables planned to be deleted
	if (!(removeVariableList)) {
		removeVariableList = [[NSMutableArray alloc] init];

	}

	//the creation of the dynamic list
	NSMutableArray *specifierList = [[NSMutableArray alloc] init];

	//create as many specifiers there are depending on the size of the array
	for (NSString *variable in imageVariableList) {

		[specifierList addObject:[self createImageSpecifier:variable]];

	}

	//load array at the end of the list... I believe...?
	[self insertContiguousSpecifiers:specifierList atEndOfGroup:1];

}

//button thing from the plist to add image cell
- (void)addImage {

	//generate unique variable name
	NSString *linkToImage = [self randomStringWithLength];

	//add newly generated variable name to the array
	[imageVariableList addObject:linkToImage];

	//create specifier with the variable name as a crucial property to be used
	[self saveImage:[self createImageSpecifier:linkToImage]];
}

//create specifier
- (PSSpecifier *)createImageSpecifier:(NSString *)linkToImage {

	//initial specifier declaration, mainly contians just setting the label
	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Image" target:self set:NULL get:NULL detail:Nil cell:PSLinkCell edit:Nil];

	//set additional properties to the specifiers, which in the case are

	//the cell type to be used, which is an image picker
	[specifier setProperty:NSClassFromString(@"GcImagePickerCell") forKey:@"cellClass"];

	//where to write the preferences
	[specifier setProperty:@"com.denial.doabarrelwallprefs" forKey:@"defaults"];

	//set variable for the image picker to properly save a copy of it in a folder on the device under the same variable name
	//so we can retrieve it later when desired
	[specifier setProperty:linkToImage forKey:@"key"];

	//allows the cell to be interactive
	[specifier setProperty:@YES forKey:@"enabled"];

	return specifier;
}

//big fat thanks to specifically GC suggesting this idea and Azzou for figuring out that this is the way to go even though we were stubborn lmao
//this method is called automatically when a cell is deleted in the editable list
//and is infinitely better than what Azzou and I initially had
- (BOOL)performDeletionActionForSpecifier:(PSSpecifier *)specifier {

	//get the index of which specifier to be deleted
	int index = [self indexPathForSpecifier:specifier].row;

	//get variable name depending on specifier being removed in order to delete actual files linked to the variable name
	NSString *variableName = [imageVariableList objectAtIndex:index];

	//add planned variable to be deleted to the removeVariablelist to be handled later
	[removeVariableList addObject:variableName];

	//remove the variable from the image list to be handled later
	[imageVariableList removeObjectAtIndex:index];

	return true;

}

// add specifier
- (void)saveImage:(PSSpecifier *)specifier {

	// Add new specifier to the controller
	[self insertSpecifier:specifier atEndOfGroup:1];
}

//links plist
- (void)loadFromSpecifier:(PSSpecifier *)specifier {

    NSString *sub = [specifier propertyForKey:@"DBWWalls"];
    NSString *title = [specifier name];

    _specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

    [self.navigationItem setTitle:title];

}

//generate random string so that each variable is unique and can't link to a previous image
- (NSString *)randomStringWithLength {

	//stackoverflow is my best friend, because this method is a direct copy and paste lol

	//mediocre string length, but long enough that the possibility of the same variable being generated isn't in this lifetime
	int stringLength = 10;
	NSMutableString *randomString = [NSMutableString stringWithCapacity:stringLength];

	//appending each singular letter one by one a total of ten times
	for (int i = 0; i < stringLength; i++) {
		[randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
	}

	//and boom the unique variable is created
	return randomString;
}

/*
	This is where the most important stuff happens.

	Up until this point, every single method that is above has been to modify TEMPORARY arrays: "imageVariableList" and "removeVariableList",
	but how this saveChanges method works requires more context.

	How the library LibGcUniversal works, from what I understand, is that when an image is selected from the image picker cell, a instance/copy of the image is
	created and saved in a folder automatically generated by the library under a folder named the same as the preferences bundle, which in this case, is
	"/var/mobile/Library/Preferences/com.denial.doabarrelwallprefs/". How the image is retrieved by the image picker to be used either as the small cell preview
	or to be used later in a view is determined by the name set to the instance/copy. The name of this instance/copy is determined by a property of the specifier
	that the image picker resides in.

	Upon creation of each specifier, there is a property of "key" that allows the use of a custom string, and this string is used to name the instance/copy.
	This is property of the specifier is specifically set like this:

	[specifier setProperty:linkToImage forKey:@"key"];

	where "linkToImage" is the unique string generated in the "addImage" method, setting the unique name for this specifier, which in turn is used by the image picker
	to appropriately name the instance/copy generated. The random generation of this string ensures that no more than one specifier can retrieve or generate the same
	instance/copy, either from the past or later in the future. Each image is always going to be unique.

	How the images are actually then retrieved to be used later in a view is in a similar way that specifiers do it to show the preview in a cell; it calls for the variable
	name of the instance/copy. But how does it know what variable names are available if they'll never be the same?

	In order to solve this issue, an array must be written into a .plist that stores the variable names that have been generated. This plist is never deleted or modified
	unless by the user, so the contents will always be the same.

	This is initally what I had, however, this can cause another issue if the contents were to be deleted, modified,
	or called so many times in quick succession. A constant update anytime a specifier were to be added, deleted, and then writing, can presumably accumulate memory quickly and
	unsafe for real-time changes. With what I had, I have encountered a terrible issue where the device becomes in a state where it is half usable, and is definitely
	a strenuous process to get out of it. So I decided to rewrite how I handle the plist and when modifying, deleting, and retrieving values.

	What "imageVariableList" is essentially a copy of the plist to access the variable names, and this array is created when this preference page is in view. Because we now have
	a temporary copy of the array, we can safely modify the values that it contains depending on what the user decides to do. If a specifier is to be created, then we add the variable name to this array, if a specifier is to be deleted
	then we remove that variable from this array. Once the user is done with their changes, the method below "saveChanges" is executed at the end. This is the only time that
	we write back into the plist to save the new data of "imageVariableList". If this method is never performed and the user leaves this page, then the contents of "imageVariableList"
	is reset and nothing is saved to the plist.

	So basically we only take a copy of the plist once, modify the contents (which in this case, are the variable names that are available for use) in a temporary array, and then writing
	the contents of the array back into the plist. We only deal with the plist a total of two times in this entire process to avoid the aforementioned memory issue.

	------------

	There is still one more issue that needs to be addressed, as for what happens to the instances/copies that are automatically generated. If a user were to remove a specifier and
	save that change, the variable name in the array plist will never exist again, but the instances/copies aren't directly affected by this change. There isn't a check by the library to see
	if an instance/copy is ever possible to retrieved, it just simply waits until a specifier with the exact same "key" variable name property is created, if one exists, then the specifier will
	see if a instance/copy exists under the same variable name, and if it does, then preview that image, and if it doesn't, then do nothing. However, because each variable name is infinitely
	generated to be unique to avoid the issue of two specifiers calling for the same instance/copy, the possibility a brand new specifier having the exact same variable name
	of the instance/copy is never going to be in our lifetime.

	So the instances/copies will forever stay on the device, never to be used again, slowly taking up space.

	What "removeVariableList" is another temporary array, but solely created to resolve this one specific issue. When the user decides to remove a specifier, this variable name will added to
	this array to keep track of which variables won't exist if the user were to save the changes. If changes are saved and variables exist in this array, then also permanently delete
	the related instances/copies. Because of the obvious convenience of the variable name being the same as the instance/copy, we can just simply find these files by hardcoding in the directory
	to search the files in, and just append the variable name to the end, and boom, instances/copies will no longer exist.

	And thus, the most important process of this entire tweak is finished.
*/
- (void)saveChanges {

	//Making it impossible for the user to save the edge case of zero images, as this can throw errors when Tweak.xm finds an array with nothing.
	if ([imageVariableList count] == 0) {

		AudioServicesPlaySystemSound(1519);

		//display friendly alert
		UIAlertController *addToggleAlert = [UIAlertController alertControllerWithTitle:@"Add two more images" message:@"Can't cycle through wallpapers that don't exist dummy." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:nil];
		[addToggleAlert addAction:dismissAction];
		[self presentViewController:addToggleAlert animated:YES completion:nil];


	/*
		Making it impossible for the user to save the edge case of one image, as this will cause an infinite while loop to be run, because there is a check to determine if the previous
		image is the same as the current chosen one. Obviously, if there's only one image available, then the previous will always be the current, so the while loop will never exit.
		And that's the story of how Azzou's phone had a conniption during testing lol
	*/
	} else if ([imageVariableList count] == 1) {

		AudioServicesPlaySystemSound(1519);

		//display friendly alert
		UIAlertController *addToggleAlert = [UIAlertController alertControllerWithTitle:@"Add one more image" message:@"What's the point of this tweak if there's one wallpaper?" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:nil];
		[addToggleAlert addAction:dismissAction];
		[self presentViewController:addToggleAlert animated:YES completion:nil];

	} else { //if the user attempts to save changes that contain least two images, which is what is intended

		//finally write to the plist to save the new contents
		[prefs setObject:imageVariableList forKey:@"imageVariableList"];

		//delete actual files created by the libGcUniversal to save space
		for (NSString *keyWord in removeVariableList) {

			[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.denial.doabarrelwallprefs/%@-PRE", keyWord] error:nil];
			[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.denial.doabarrelwallprefs/%@-IMG", keyWord] error:nil];

		}

		[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=DoABarrelWall"]];

	}

}

//something necessary
- (void)setSpecifier:(PSSpecifier *)specifier {

	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];

}

/*
	forces users to reload return to this page when out of the app (not counting app switching)
	this is the unfortunately the only thing I don't like about this tweak,
	but having the return value set to NO crashes the preferences, and I have literally no idea why, the crash log doesn't help
	so basically this is a garbage way to avoid this issue, but good enough for me
*/
- (BOOL)shouldReloadSpecifiersOnResume {
	return YES;
}

@end