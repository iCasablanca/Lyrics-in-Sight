//
//  PanelController.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "PanelController.h"
#import "AppController.h"
#import "AbstractNotifier.h"
#import "NotifierFactory.h"


@implementation PanelController

@synthesize type;

#pragma mark initialize and set up methods
- (id)initWithController:(AppController *)aController andType:(NSString *)aType;
{
	if (![super initWithWindowNibName:@"Panel"])
		return nil;
	controller = aController;
	
	[self setShouldCascadeWindows:NO];
	rect = NSMakeRect(500, 500, 500, 300); // Defautls
	type = aType;
	
	notifier = [NotifierFactory getNotifierForPanelController:self];
	[notifier registerPanelController:self];
	
	return self;
}

#pragma mark  converting the content stored in NSUserDefualts to and from a dictionary
- (id)initWithController:(AppController *)aController andDictionary:(NSDictionary *)aDictionary;
{
	if (![self initWithController:aController andType:[aDictionary objectForKey:@"Type"]])
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
	[dictionary setObject:type forKey:@"Type"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.origin.x] forKey:@"X"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.origin.y] forKey:@"Y"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.size.width] forKey:@"Width"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.size.height] forKey:@"Height"];
	return dictionary;
}

#pragma mark  panel content management methods
- (void)update:(NSDictionary *)songInfo
{
	if (songInfo == nil) {
		[textView setString:@""];
		return;
	}
	
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

#pragma mark NSWindow delegate methods
-(void)windowDidLoad
{
	NSRect frame = [[self window] frame];
	[[self window] setMovable:NO];
	//	[[self window] setLevel:kCGDesktopIconWindowLevel];
	[[self window] setFrame:rect display:YES animate:YES];
	
	[self editModeStopped];
	
	[notifier requestUpdate:self];
	
	frame = [[self window] frame];
	
	[[self window] display];
}

- (void)windowDidMove:(NSNotification *)windowDidMoveNotification
{
	rect = [[windowDidMoveNotification object] frame];
}

- (void)windowDidResize:(NSNotification *)windowDidResizeNotification
{
	rect = [[windowDidResizeNotification object] frame];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[notifier unregisterPanelController:self];
	[controller removePanel:self];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%f, %f: %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

@end
