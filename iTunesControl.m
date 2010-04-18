//
//  ITunesControl.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "iTunesControl.h"
#import "AppController.h"
#import "LyricsFinder.h"

@implementation iTunesControl

-(id) initWithController:(AppController *)aController
{
	if (![super init])
		return nil;
	iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	controller = aController;
	
	if ([iTunes isRunning]) { // fill dictionary with AppleScript
		songInfo = [NSMutableDictionary dictionary];
		
		iTunesTrack *currentTrack = [iTunes currentTrack];
		
		NSString *artist = [currentTrack artist];
		artist = (artist == nil) ? @"" : artist;
		[songInfo setObject:artist forKey:@"Artist"];
		
		NSString *album = [currentTrack album];
		album = (album == nil) ? @"" : album;
		[songInfo setObject:album forKey:@"Album"];
		
		NSString *title = [currentTrack name];
		title = (title == nil) ? @"" : title;
		[songInfo setObject:title forKey:@"Name"];
		
		NSString *lyrics	= [currentTrack lyrics];
		lyrics = (lyrics == nil) ? @"" : lyrics;
		[songInfo setObject:lyrics forKey:@"Lyrics"];
		
		[controller updatePanels:songInfo];
	}
	
	return self;
}

-(void) songChanged:(NSNotification *) aNotification
{
	NSDictionary *userInfo = [aNotification userInfo];
	NSLog(@"%@", userInfo);
	NSString *playerState = [userInfo objectForKey:@"Player State"];
	if ( [playerState isEqualToString:@"Stopped"] ) {
		[controller clearPanels];
		return;
	} else {
		// need to load lyrics extra (because not included in notification)
		NSString *lyrics	= [[iTunes currentTrack] lyrics];
		lyrics = (lyrics == nil) ? @"" : lyrics;
		
		if ([lyrics isEqualToString: @""]) { // find lyrics, if lyrics are not set
			lyrics = [LyricsFinder findLyricsOf:[userInfo objectForKey:@"Name"]
																			 by:[userInfo objectForKey:@"Artist"]];
			// uncomment the following line to automatically set lyric of song, if found
//			if (![lyrics isEqualToString:@""]) { // set lyrics of song via iTunes 
//				[[iTunes currentTrack] setLyrics:lyrics];
//			}
		} 
		
		songInfo = nil; // clear Dictionary
		songInfo = [userInfo mutableCopy];
		[songInfo setObject:lyrics forKey:@"Lyrics"]; // add lyrics
		[controller updatePanels:songInfo];
	}
}

-(NSDictionary *)getSongInfo
{
	return songInfo;
}

@end
