//
//  AppDelegate.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSString * const LiSPanelCount = @"PanelCount";
NSString * const LiSPanelDefaults = @"PanelDefaults";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self createMenu];
	[self registeringUserDefaults];
	inEditMode = FALSE;
	
	iTC = [[iTunesControl alloc] initWithController:self];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:iTC
																											selector:@selector(songChanged:)
																													name:@"com.apple.iTunes.playerInfo"
																												object:nil];
	[self creatingPanels];
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

- (void)registeringUserDefaults
{
	// inititalize default user defaults
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	[defaultValues setObject:[NSNumber numberWithInt:1]
										forKey:LiSPanelCount];
	
	PanelController *panel = [[PanelController alloc] init];
	
	[defaultValues setObject:[NSArray arrayWithObject:panel]
										forKey:LiSPanelDefaults];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)creatingPanels
{
	panelController = [NSMutableArray arrayWithCapacity:[self panelCount]];
	
	for (int i = 0; i < [self panelCount]; i++) {
//		PanelController *controller = [[PanelController alloc] init];
		PanelController *controller = [self panelAtIndex:i];
		[controller setController:self];
		[controller showWindow:self];
		[panelController addObject:controller];
	}
}

- (NSInteger)panelCount
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:LiSPanelCount];
}

- (void)setPanelCount:(NSInteger)newCount
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newCount]
																						forKey:LiSPanelCount];
}

- (PanelController *)panelAtIndex:(NSInteger)i
{
	NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:LiSPanelDefaults];
	return [array objectAtIndex:i];
}

- (void)addPanel:(id)sender
{
	PanelController *controller = [[PanelController alloc] initWithController:self];
	[controller showWindow:self];
	[panelController addObject:controller];
	
	[self setPanelCount:[self panelCount] + 1];
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
