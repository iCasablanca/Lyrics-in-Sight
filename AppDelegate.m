//
//  AppDelegate.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	controller = [[AppController alloc] init];
	
	[controller createStatusItem];
	
	[controller registeringUserDefaults];
	[controller loadUserDefaults];
	
	[controller createPanels];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	[controller saveUserDefaults];
	return NSTerminateNow;
}


@end
