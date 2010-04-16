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
	[theMenu addItemWithTitle:@"Add Panel" 
										 action:@selector(addPanel:) 
							keyEquivalent:@""];
	[theMenu addItemWithTitle:@"Edit Panels"
										 action:@selector(switchEditMode:)
							keyEquivalent:@""];
	[theMenu addItemWithTitle:@"Quit Lyrics in Sight"
										 action:@selector(terminate:)
							keyEquivalent:@""];
	
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
	if (inEditMode) {
		for (int i = 0; i < [panelController count]; i++) {
			[[panelController objectAtIndex:i] editModeStoped];
		}
	} else {
		for (int i = 0; i < [panelController count]; i++) {
			[[panelController objectAtIndex:i] editModeStarted];
		}
	}
}

- (NSDictionary *)getSongInfo
{
	return [iTC getSongInfo];
}

@end
