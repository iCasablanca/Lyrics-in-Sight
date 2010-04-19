//
//  iTunesNotifier.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "iTunesNotifier.h"
#import "iTunes.h"
#import "AppController.h"
#import "LyricsFinder.h"

static iTunesNotifier *instance = nil;

@implementation iTunesNotifier

+ (iTunesNotifier *)instance
{
	@synchronized(self)
	{
		if (instance == nil)
			instance = [[iTunesNotifier alloc] init];
	}
	return instance;
}

-(id) init
{
	if (![super init])
		return nil;
	iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self
																											selector:@selector(songChanged:)
																													name:@"com.apple.iTunes.playerInfo"
																												object:nil];
	userInfo = nil;
	return self;
}

-(void) songChanged:(NSNotification *) aNotification
{
	NSDictionary *songInfo = [aNotification userInfo];
	NSString *playerState = [songInfo objectForKey:@"Player State"];
	if ( [playerState isEqualToString:@"Stopped"] ) {
		userInfo = nil;
	} else {
		// need to load lyrics extra (because not included in notification)
		NSString *lyrics	= [[iTunes currentTrack] lyrics];
		lyrics = (lyrics == nil) ? @"" : lyrics;
		
		if ([lyrics isEqualToString: @""]) { // find lyrics, if lyrics are not set
			lyrics = [LyricsFinder findLyricsOf:[songInfo objectForKey:@"Name"]
																			 by:[songInfo objectForKey:@"Artist"]];
			// uncomment the following line to automatically set lyric of song, if found
//			if (![lyrics isEqualToString:@""]) { // set lyrics of song via iTunes 
//				[[iTunes currentTrack] setLyrics:lyrics];
//			}
		} 
		
		userInfo = [songInfo mutableCopy];
		[userInfo setObject:lyrics forKey:@"Lyrics"]; // add lyrics
	}
	
	for (PanelController *controller in panelControllers) {
		[controller update:userInfo];
	}
}

- (void)requestUpdate:(PanelController *)aController
{
	if (userInfo == nil) {
		if ([iTunes isRunning]) { // fill dictionary with AppleScript
			userInfo = [NSMutableDictionary dictionary];
			iTunesTrack *currentTrack = [iTunes currentTrack];
			
			NSString *artist = [currentTrack artist];
			artist = (artist == nil) ? @"" : artist;
			[userInfo setObject:artist forKey:@"Artist"];
			
			NSString *album = [currentTrack album];
			album = (album == nil) ? @"" : album;
			[userInfo setObject:album forKey:@"Album"];
			
			NSString *title = [currentTrack name];
			title = (title == nil) ? @"" : title;
			[userInfo setObject:title forKey:@"Name"];
			
			NSString *lyrics	= [currentTrack lyrics];
			lyrics = (lyrics == nil) ? @"" : lyrics;
			[userInfo setObject:lyrics forKey:@"Lyrics"];
		} else {
			// print "iTunes not running"
		}
	}
	[aController update:userInfo];
}

@end
