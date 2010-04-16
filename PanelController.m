//
//  PanelController.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "PanelController.h"


@implementation PanelController

- (id)init
{
	if (![super initWithWindowNibName:@"Panel"])
		return nil;
	return self;
}

- (void)windowWillLoad
{
	
}

- (void)windowDidLoad
{
	[[self window] setLevel:kCGDesktopIconWindowLevel];
}

- (void)clear
{
	[textView setString:@""];
}

- (void)update:(NSDictionary *)songInfo
{
	NSString *artist	= [songInfo objectForKey:@"Artist"];
	artist =  (artist == nil) ? @"" : artist;
	NSString *album		= [songInfo objectForKey:@"Album"];
	album = (album == nil) ? @"" : album;
	NSString *title		= [songInfo objectForKey:@"Name"];
	title = (title == nil) ? @"" : title;
	NSString *lyrics	= [songInfo objectForKey:@"Lyrics"];
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

@end
