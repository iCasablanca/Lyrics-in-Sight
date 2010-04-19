//
//  AppController.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 18.04.10.
//

#import "AppController.h"


@implementation AppController

#pragma mark initialize methods
- (id)init
{
	if (![super init])
		return nil;
	inEditMode = FALSE;
	iTC = [[iTunesControl alloc] initWithController:self];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:iTC
																											selector:@selector(songChanged:)
																													name:@"com.apple.iTunes.playerInfo"
																												object:nil];
	return self;
}

#pragma mark start up methods
- (void)createStatusItem
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
	[item setTag:ADD_PANEL_MENU_ITEM];
	[theMenu addItem:item];
	
	item = [[NSMenuItem alloc] initWithTitle:@"Edit Panels"
																		action:@selector(switchEditMode:)
														 keyEquivalent:@""];
	[item setTarget:self];
	[item setTag:EDIT_MODE_MENU_ITEM];
	[theMenu addItem:item];
	
	item = [[NSMenuItem alloc] initWithTitle:@"Quit Lyrics in Sight"
																		action:@selector(terminate:)
														 keyEquivalent:@""];
	[item setTag:QUIT_LYRICS_IN_SIGHT_MENU_ITEM];
	[theMenu addItem:item];
	
	[statusItem setMenu:theMenu];
}

- (void)createPanels
{	
	for (int i = 0; i < panelCount; i++) {
		PanelController *controller = [panelController objectAtIndex:i];
		[controller setController:self];
		[controller showWindow:self];
	}
}

#pragma mark user default management
NSString * const LiSPanelCount = @"PanelCount";
NSString * const LiSPanelControllers = @"PanelControllers";

- (void)registerUserDefaults
{
	// inititalize default user defaults
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	[defaultValues setObject:[NSNumber numberWithInt:1]
										forKey:LiSPanelCount];
	
	PanelController *panel = [[PanelController alloc] init];
	
	NSMutableArray *panels = [NSMutableArray arrayWithObject:[panel dictionary]];
	
	[defaultValues setObject:panels
										forKey:LiSPanelControllers];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)loadUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	panelCount = [defaults integerForKey:LiSPanelCount];

	panelController = [NSMutableArray arrayWithCapacity:panelCount];
	NSArray *panelControllerAsDictionaries = [defaults objectForKey:LiSPanelControllers];
	for (int i = 0; i < panelCount; i++) {
		NSDictionary *dict = [panelControllerAsDictionaries objectAtIndex:i];
		[panelController insertObject:[[PanelController alloc] initWithDictionary:dict]
													atIndex:i];
	}
}

- (void)saveUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithInt:panelCount]
							 forKey:LiSPanelCount];
	NSMutableArray *panelControllerAsDictionaries = [NSMutableArray arrayWithCapacity:panelCount];
	for (int i = 0; i < panelCount; i++) {
		[panelControllerAsDictionaries insertObject:[[panelController objectAtIndex:i] dictionary]
																				atIndex:i];
	}
	[defaults setObject:panelControllerAsDictionaries
							 forKey:LiSPanelControllers];
}

#pragma mark trigger edit mode
- (void)switchEditMode:(id)sender
{
	if (inEditMode) { // switch to normal mode
		for (int i = 0; i < [panelController count]; i++) {
			[[panelController objectAtIndex:i] editModeStopped];
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

#pragma mark panel management
- (void)addPanel:(id)sender
{
	panelCount++;
	PanelController *controller = [[PanelController alloc] init];
	[panelController addObject:controller];
	
	[controller setController:self];
	[controller showWindow:self];
	
	// save change to user defaults
	[self saveUserDefaults];
}

- (void)removePanel:(PanelController *)aController
{
	[panelController removeObject:aController];	
	panelCount--;
	
	// save change to user defaults
	[self saveUserDefaults];
}

#pragma mark panel content management
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

- (NSDictionary *)getSongInfo
{
	return [iTC getSongInfo];
}

@end
