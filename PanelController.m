//
//  PanelController.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "PanelController.h"
#import "AppDelegate.h"


@implementation PanelController

- (id)init
{
	if (![super initWithWindowNibName:@"Panel"])
		return nil;
	controller = nil;
	rect = NSMakeRect(500, 500, 500, 300); // Defaults
	
	
	return self;
}

- (id)initWithController:(AppDelegate *)aController
{
	self = [self init];
	controller = aController;
	return self;
}

// NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
	NSLog(@"initWithCoder");
	self = [self init];
	rect = [decoder decodeRectForKey:@"Rect"];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	NSLog(@"encodeWithCoder");
	[super encodeWithCoder:encoder];
	[encoder encodeRect:rect forKey:@"Rect"];
}

- (void)setController:(AppDelegate *)aController
{
	controller = aController;
}

- (void)windowDidMove:(NSNotification *)windowDidMoveNotification
{
	rect = [[windowDidMoveNotification object] frame];
}

- (void)windowDidResize:(NSNotification *)windowDidResizeNotification
{
	rect = [[windowDidResizeNotification object] frame];
}

- (void)windowWillLoad
{
	
}

- (void)windowDidLoad
{
	[[self window] setMovable:NO];
	//	[[self window] setLevel:kCGDesktopIconWindowLevel];
	[[self window] setFrame:rect display:NO];
	[self update:[controller getSongInfo]];
	[[self window] display];
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

- (void)editModeStarted
{
	[[self window] setMovable:YES];
	// add closeable and resizable to the mask
	[[self window] setStyleMask:[[self window] styleMask] | NSClosableWindowMask | NSResizableWindowMask];
	// make text editable and selectable
	[textView setEditable:YES];
	[textView setSelectable:YES];
}

- (void)editModeStoped
{
	[[self window] setMovable:NO];
	// remove closeable and resizable from the mask
	[[self window] setStyleMask:[[self window] styleMask] & ~NSClosableWindowMask & ~NSResizableWindowMask];
	[textView setEditable:NO];
	[textView setSelectable:NO];
	[textView updateInsertionPointStateAndRestartTimer:NO]; // delete cursor (insertion Point)
}


@end
