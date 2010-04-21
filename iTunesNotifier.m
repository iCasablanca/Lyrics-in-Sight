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
	whitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:@" \t"];
	return self;
}

-(void) songChanged:(NSNotification *) aNotification
{
	NSDictionary *songInfo = [aNotification userInfo];
	userInfo = [songInfo mutableCopy];
	
	if ([iTunes currentTrack] != nil) {
		[userInfo setObject:[self lyricsOfTrack:[iTunes currentTrack]] 
								 forKey:@"Lyrics"]; // add lyrics
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
			
			iTunesEPlS state = [iTunes playerState];
			switch (state) {
				case iTunesEPlSStopped:
					[userInfo setObject:@"Stopped" forKey:@"Player State"];
					break;
				case iTunesEPlSPlaying:
					[userInfo setObject:@"Playing" forKey:@"Player State"];
					break;
				case iTunesEPlSPaused:
					[userInfo setObject:@"Paused" forKey:@"Player State"];
					break;
				case iTunesEPlSFastForwarding:
					[userInfo setObject:@"Fast Forwarding" forKey:@"Player State"];
					break;
				case iTunesEPlSRewinding:
					[userInfo setObject:@"Rewinding" forKey:@"Player State"];
					break;
			}
			
			iTunesTrack *currentTrack = [iTunes currentTrack];
			if (currentTrack != nil) {
				
				if ([currentTrack album])
					[userInfo setObject:[currentTrack album] 
											 forKey:@"Album"];

				if ([currentTrack albumArtist])
					[userInfo setObject:[currentTrack albumArtist] 
											 forKey:@"Album Artist"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack albumRating]]
										 forKey:@"Album Rating"];
				
				if ([currentTrack artist])
					[userInfo setObject:[currentTrack artist] 
											 forKey:@"Artist"];

				[userInfo setObject:[NSNumber numberWithInt:[[currentTrack artworks] count]] 
										 forKey:@"Artwork Count"];
				
				[userInfo setObject:[NSNumber numberWithBool:[currentTrack compilation]]
										 forKey:@"Compilation"];
				
				if ([currentTrack composer])
					[userInfo setObject:[currentTrack composer] 
											 forKey:@"Composer"];
				
				if ([currentTrack objectDescription])
					[userInfo setObject:[currentTrack objectDescription] 
											 forKey:@"Description"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack discCount]] 
										 forKey:@"Disc Count"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack discNumber]] 
										 forKey:@"Disc Number"];
				
				[userInfo setObject:[NSNumber numberWithBool:[currentTrack gapless]]
										 forKey:@"GaplessAlbum"];
				
				if ([currentTrack genre])
					[userInfo setObject:[currentTrack genre] 
											 forKey:@"Genre"];
				
				if ([currentTrack grouping])
					[userInfo setObject:[currentTrack grouping] 
											 forKey:@"Grouping"];
				
				if ([currentTrack name])
					[userInfo setObject:[currentTrack name] 
											 forKey:@"Name"];
				
				if ([currentTrack persistentID])
					[userInfo setObject:[currentTrack persistentID] 
											 forKey:@"PersistentID"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack playedCount]] 
										 forKey:@"Play Count"];
				
				if ([currentTrack playedDate])
					[userInfo setObject:[currentTrack playedDate]
											 forKey:@"Play Date"];

				[userInfo setObject:[NSNumber numberWithInt:[currentTrack rating]]
										 forKey:@"Rating Computed"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack skippedCount]]
										 forKey:@"Skip Count"];
				
				if ([currentTrack skippedDate])
					[userInfo setObject:[currentTrack skippedDate]
											 forKey:@"Skip Date"];
				
				[userInfo setObject:[NSNumber numberWithDouble:[currentTrack duration] * 1000.0]
										 forKey:@"Total Time"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack trackCount]]
										 forKey:@"Track Count"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack trackNumber]]
										 forKey:@"Track Number"];
				
				[userInfo setObject:[NSNumber numberWithInt:[currentTrack year]]
										 forKey:@"Year"];
				
				[userInfo setObject:[self lyricsOfTrack:currentTrack]
											forKey:@"Lyrics"];
			}
		} else {
			userInfo = [NSDictionary dictionary];
		}
	}
	[aController update:userInfo];
}

- (NSString *)lyricsOfTrack:(iTunesTrack *)track
{
	NSAssert(track != nil, @"track is nil");
	NSString *lyrics	= [track lyrics];
	lyrics = (lyrics == nil) ? @"" : lyrics;
	
	if ([lyrics isEqualToString: @""]) { // find lyrics, if lyrics are not set
		NSString *title  = [track name];
		NSString *artist = [track artist];
		if (title != nil && artist != nil) {
			lyrics = [LyricsFinder findLyricsOf:[track name]
																			 by:[track artist]];
			// uncomment the following line to automatically set lyric of song, if found
			//			if (![lyrics isEqualToString:@""]) { // set lyrics of song via iTunes 
			//				[[iTunes currentTrack] setLyrics:lyrics];
			//			}
		}
	}
	
	if ([lyrics length] > 0) {
		lyrics = [lyrics stringByReplacingOccurrencesOfString:@"\r\n" 
																							 withString:@"\n"];
		lyrics = [lyrics stringByReplacingOccurrencesOfString:@"\r" 
																							 withString:@"\n"];
		NSArray* lines = [lyrics componentsSeparatedByString:@"\n"];
		NSMutableArray* newLines = [NSMutableArray arrayWithCapacity:[lines count]];
		for (NSString* line in lines) {
			[newLines addObject:[line stringByTrimmingCharactersInSet:whitespaceCharacters]];
		}
		lyrics = [newLines componentsJoinedByString:@"\n"];
	}
  return lyrics;
}

@end
