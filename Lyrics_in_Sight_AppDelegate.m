//
//  Lyrics_in_Sight_AppDelegate.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "Lyrics_in_Sight_AppDelegate.h"

@implementation Lyrics_in_Sight_AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[Menulet showMenuIcon];
	[window setLevel:kCGDesktopIconWindowLevel]; // TODO: remove to earlier time
	[[NSDistributedNotificationCenter defaultCenter] addObserver:iTC selector:@selector(songChanged:) name:@"com.apple.iTunes.playerInfo" object:nil];
}

@end
