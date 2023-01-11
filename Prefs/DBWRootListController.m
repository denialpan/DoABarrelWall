#import "DBWRootListController.h"

#define contributorsURL @"https://github.com/denialpan/DoABarrelWall/blob/main/README.md#Credits"

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

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:contributorsURL] options:@{} completionHandler:nil];

}

- (void)resetPreferences {

	[prefs removeAllObjects];

	[[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/com.denial.doabarrelwallprefs/" error:nil];
	[self respringUtil];

}

- (void)respringUtil {

	[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=DoABarrelWall"]];

}

@end
