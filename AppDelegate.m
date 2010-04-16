//
//  AppDelegate.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self createMenu];
	[self loadPanels];
	iTC = [[ITunesControl alloc] initWithController:self];
	PanelController *controller = [[PanelController alloc] init];
	[controller showWindow:self];
	[panelController addObject:controller];
	
	//[window setLevel:kCGDesktopIconWindowLevel]; // TODO: remove to earlier time
	[[NSDistributedNotificationCenter defaultCenter] addObserver:iTC
																											selector:@selector(songChanged:)
																													name:@"com.apple.iTunes.playerInfo" object:nil];
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
	[item setTarget:self];
	[theMenu addItem:item];
	
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
	NSLog(@"updatePanels called");
	NSLog(@"%d", [panelController count]);
	for	(int i = 0; i < [panelController count]; i++) {
		[[panelController objectAtIndex:i] update:songInfo];
	}
}

@end
