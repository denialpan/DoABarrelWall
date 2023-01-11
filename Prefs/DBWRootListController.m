#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>
#import <spawn.h>
#import "DBWRootListController.h"

HBPreferences *prefs;

@implementation DBWRootListController

- (instancetype)init {

	if (!(self = [super init])) {
		return self;
	}

	prefs = [[HBPreferences alloc] initWithIdentifier: @"com.denial.doabarrelwallprefs"];
	return self;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}


	return _specifiers;
}

- (void)contributorsList {

	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/denialpan/DoABarrelWall/blob/main/README.md#Credits"]
	options:@{}
	completionHandler:nil];

}

- (void)resetPreferences {

	prefs = [[HBPreferences alloc] initWithIdentifier: @"com.denial.doabarrelwallprefs"];
	[prefs removeAllObjects];

	[[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/com.denial.doabarrelwallprefs/" error:nil];
	[self respringUtil];

}

- (void)respringUtil {

	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=DoABarrelWall"]];
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);

}

@end
