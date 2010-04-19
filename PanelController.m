//
//  PanelController.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "PanelController.h"
#import "AppController.h"


@implementation PanelController

#pragma mark initialize and set up methods
- (id)init
{
	if (![super initWithWindowNibName:@"Panel"])
		return nil;
	[self setShouldCascadeWindows:NO];
	controller = nil;
	rect = NSMakeRect(500, 500, 500, 300); // Defaults
	
	
	return self;
}

- (id)initWithController:(AppController *)aController
{
	if (![self init])
		return nil;
	controller = aController;
	return self;
}

- (void)setController:(AppController *)aController
{
	controller = aController;
}

#pragma mark  panel content management methods
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

#pragma mark  edit mode management methods
- (void)editModeStarted
{
	[[self window] setMovable:YES];
	// add closeable and resizable to the mask
	[[self window] setStyleMask:[[self window] styleMask] | NSClosableWindowMask | NSResizableWindowMask | NSTitledWindowMask | NSUtilityWindowMask];
	// make text editable and selectable
	[textView setEditable:YES];
	[textView setSelectable:YES];
}

- (void)editModeStopped
{
	[[self window] setMovable:NO];
	// remove closeable and resizable from the mask
	[[self window] setStyleMask:[[self window] styleMask] & ~NSClosableWindowMask & ~NSResizableWindowMask & ~NSTitledWindowMask & ~NSUtilityWindowMask];
	[textView setEditable:NO];
	[textView setSelectable:NO];
	[textView updateInsertionPointStateAndRestartTimer:NO]; // delete cursor (insertion Point)
}

#pragma mark  converting the content stored in NSUserDefualts to and from a dictionary
- (id)initWithDictionary:(NSDictionary *)aDictionary
{
	if (![self init])
		return nil;
	rect.origin.x			= [[aDictionary objectForKey:@"X"] floatValue];
	rect.origin.y			= [[aDictionary objectForKey:@"Y"] floatValue];
	rect.size.width		= [[aDictionary objectForKey:@"Width"] floatValue];
	rect.size.height	= [[aDictionary objectForKey:@"Height"] floatValue];
	return self;
}

- (NSDictionary *)dictionary
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:[NSNumber numberWithFloat:rect.origin.x] forKey:@"X"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.origin.y] forKey:@"Y"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.size.width] forKey:@"Width"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.size.height] forKey:@"Height"];
	return dictionary;
}

#pragma mark NSWindowController methods
-(void)windowDidLoad
{
	NSRect frame = [[self window] frame];
	[[self window] setMovable:NO];
	//	[[self window] setLevel:kCGDesktopIconWindowLevel];
	[[self window] setFrame:rect display:YES animate:YES];
	
	[self editModeStopped];
	
	if (controller != nil) {
		[self update:[controller getSongInfo]];
	}
	
	frame = [[self window] frame];
	NSLog(@"Frame: %f, %f", frame.origin.x, frame.origin.y);
	
	[[self window] display];
}

- (void)windowDidMove:(NSNotification *)windowDidMoveNotification
{
	rect = [[windowDidMoveNotification object] frame];
	NSLog(@"%f, %f", rect.origin.x, rect.origin.y);
}

- (void)windowDidResize:(NSNotification *)windowDidResizeNotification
{
	rect = [[windowDidResizeNotification object] frame];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[controller removePanel:self];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%f, %f: %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

@end
