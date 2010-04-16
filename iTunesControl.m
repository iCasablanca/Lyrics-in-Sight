//
//  iTunesControl.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "iTunesControl.h"


@implementation iTunesControl

-(id) init
{
	if (![super init])
		return nil;
	iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	return self;
}

-(void) songChanged:(NSNotification *) aNotification
{
	NSDictionary *userInfo = [aNotification userInfo];
	NSLog(@"%@", userInfo);
	NSString *playerState = [userInfo objectForKey:@"Player State"];
	if ( [playerState isEqualToString:@"Stopped"] ) {
		// TODO: cleanup
		[textView setString:@""];
		return;
	} else {
		NSString *artist	= [userInfo objectForKey:@"Artist"];
		artist =  (artist == nil) ? @"" : artist;
		NSString *album		= [userInfo objectForKey:@"Album"];
		album = (album == nil) ? @"" : album;
		NSString *title		= [userInfo objectForKey:@"Name"];
		title = (title == nil) ? @"" : title;
		NSString *lyrics	= [[iTunes currentTrack] lyrics];
		lyrics = (lyrics == nil) ? @"" : lyrics;
		// TODO: get and set lyrics:
		// [[iTunes currentTrack] setLyrics:album];
		
		NSMutableString *output = [[NSMutableString alloc] init];
		[output appendString:title];
		[output appendString:@" / "];
		[output appendString:artist];
		[output appendString:@" / "];
		[output appendString:album];
		[output appendString:@"\n\n"];
		[output appendString:lyrics];
		
		[textView setString:output];
	}
}

@end
