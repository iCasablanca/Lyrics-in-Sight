//
//  AppDelegate.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	inEditMode = FALSE;
	[self createMenu];
	[self loadPanels];
	iTC = [[iTunesControl alloc] initWithController:self];
	
	PanelController *controller = [[PanelController alloc] initWithController:self];
	[controller showWindow:self];
	[panelController addObject:controller];
	
	[[NSDistributedNotificationCenter defaultCenter] addObserver:iTC
																											selector:@selector(songChanged:)
																													name:@"com.apple.iTunes.playerInfo"
																												object:nil];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self
																											selector:@selector(notification:)
																													name:nil
																												object:nil];
}

- (void)notification:(NSNotification *) aNotification
{
	NSLog(@"%@", aNotification);
}

- (void)createMenu
{
	NSMenu        *theMenu;
	statusItem = [[NSStatusBar systemStatusBar] 
								statusItemWithLength:NSVariableStatusItemLength];
	[statusItem setImage:[NSImage imageNamed:@"menubaricon"]];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString 
												stringWithString:@""]]; 
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@""];
	
	theMenu = [[NSMenu alloc] initWithTitle:@""];	
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Add Panel"
																								action:@selector(addPanel:)
																				 keyEquivalent:@""];
	[item setTag:ADD_PANEL_MENU_ITEM];
	[theMenu addItem:item];
	
	item = [[NSMenuItem alloc] initWithTitle:@"Edit Panels"
																		action:@selector(switchEditMode:)
														 keyEquivalent:@""];
	[item setTag:EDIT_MODE_MENU_ITEM];
	[theMenu addItem:item];
	
	item = [[NSMenuItem alloc] initWithTitle:@"Quit Lyrics in Sight"
																		action:@selector(terminate:)
														 keyEquivalent:@""];
	[item setTag:QUIT_LYRICS_IN_SIGHT_MENU_ITEM];
	[theMenu addItem:item];
	
	[statusItem setMenu:theMenu];
}

- (void)loadPanels
{
	// TODO: load Panels from user defaults
	panelController = [NSMutableArray array];
}

- (void)addPanel:(id)sender
{
	PanelController *controller = [[PanelController alloc] init];
	[controller showWindow:self];
	[panelController addObject:controller];
}

- (void)clearPanels
{
	for (int i = 0; i < [panelController count]; i++) {
		[[panelController objectAtIndex:i] clear];
	}
}

- (void)updatePanels:(NSDictionary *)songInfo
{
	for	(int i = 0; i < [panelController count]; i++) {
		[[panelController objectAtIndex:i] update:songInfo];
	}
}

- (void)switchEditMode:(id)sender
{
	if (inEditMode) { // switch to normal mode
		for (int i = 0; i < [panelController count]; i++) {
			[[panelController objectAtIndex:i] editModeStoped];
		}
		[[[statusItem menu] itemWithTag:EDIT_MODE_MENU_ITEM] setState:NSOffState];
	} else { // switch to edit mode
		for (int i = 0; i < [panelController count]; i++) {
			[[panelController objectAtIndex:i] editModeStarted];
		}
		[[[statusItem menu] itemWithTag:EDIT_MODE_MENU_ITEM] setState:NSOnState];
	}
	inEditMode = ~inEditMode;
}

- (NSDictionary *)getSongInfo
{
	return [iTC getSongInfo];
}

@end
