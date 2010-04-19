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
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[statusItem setImage:[NSImage imageNamed:@"menubaricon"]];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString stringWithString:@""]]; 
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@""];
	
	NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@""]; // create menu
	
	NSMenuItem *item = nil;
	
	NSMenu *addPanelMenu = [[NSMenu alloc] initWithTitle:@""]; // create submenu (late attached to item)
	
	// get all availabe valid types from controller factory to create menu items for them
	for (NSString *type in [ControllerFactory validTypes]) {
		item = [[NSMenuItem alloc] initWithTitle:type
																			action:@selector(addPanel:)
															 keyEquivalent:@""];
		[item setTarget:self];
		[item setTag:ADD_PANEL_MENU_ITEM];
		[addPanelMenu addItem:item]; // add items to submenu
	}
	// "Add Panel" item is a submenu
	item = [[NSMenuItem alloc] initWithTitle:@"Add Panel"
																		action:nil
														 keyEquivalent:@""];
	[theMenu addItem:item]; // create item
	[theMenu setSubmenu:addPanelMenu forItem:item]; // attach submenu to item
	
	// "Edit Panels" item
	item = [[NSMenuItem alloc] initWithTitle:@"Edit Panels"
																		action:@selector(switchEditMode:)
														 keyEquivalent:@""];
	[item setTarget:self];
	[item setTag:EDIT_MODE_MENU_ITEM];
	[theMenu addItem:item];
	
	
	// "Quit Lyrics in Sight" item
	item = [[NSMenuItem alloc] initWithTitle:@"Quit Lyrics in Sight"
																		action:@selector(terminate:)
														 keyEquivalent:@""];
	[item setTag:QUIT_LYRICS_IN_SIGHT_MENU_ITEM];
	[theMenu addItem:item];
	
	[statusItem setMenu:theMenu];
}

- (void)createPanels
{	
	for(PanelController *controller in panelControllers) {
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
	
	[defaultValues setObject:[NSNumber numberWithInt:0]
										forKey:LiSPanelCount];

	[defaultValues setObject:[NSMutableArray array]
										forKey:LiSPanelControllers];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)loadUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	panelControllers = [NSMutableArray array];
	NSArray *panelControllerAsDictionaries = [defaults objectForKey:LiSPanelControllers];
	for (NSDictionary *dict in panelControllerAsDictionaries ) {
		[panelControllers addObject:[[PanelController alloc] initWithController:self
																																andDictionary:dict]];
	}
}

- (void)saveUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *panelControllerAsDictionaries = [NSMutableArray arrayWithCapacity:[panelControllers count]];
	for (PanelController *controller in panelControllers) {
		[panelControllerAsDictionaries addObject:[controller dictionary]];
	}
	[defaults setObject:panelControllerAsDictionaries
							 forKey:LiSPanelControllers];
}

#pragma mark trigger edit mode
- (void)switchEditMode:(id)sender
{
	if (inEditMode) { // switch to normal mode
		for (int i = 0; i < [panelControllers count]; i++) {
			[[panelControllers objectAtIndex:i] editModeStopped];
		}
		[[[statusItem menu] itemWithTag:EDIT_MODE_MENU_ITEM] setState:NSOffState];
	} else { // switch to edit mode
		for (int i = 0; i < [panelControllers count]; i++) {
			[[panelControllers objectAtIndex:i] editModeStarted];
		}
		[[[statusItem menu] itemWithTag:EDIT_MODE_MENU_ITEM] setState:NSOnState];
	}
	inEditMode = ~inEditMode;
}

#pragma mark panel management
- (void)addPanel:(id)sender
{
	PanelController *controller = [[PanelController alloc] initWithController:self
																																		andType:[sender title]];
	[panelControllers addObject:controller];
	
	[controller showWindow:self];
	
	// save change to user defaults
	[self saveUserDefaults];
}

- (void)removePanel:(PanelController *)aController
{
	[panelControllers removeObject:aController];
	
	// save change to user defaults
	[self saveUserDefaults];
}

#pragma mark panel content management
- (void)clearPanels
{
	for (int i = 0; i < [panelControllers count]; i++) {
		[[panelControllers objectAtIndex:i] clear];
	}
}

- (void)updatePanels:(NSDictionary *)songInfo
{
	for	(int i = 0; i < [panelControllers count]; i++) {
		[[panelControllers objectAtIndex:i] update:songInfo];
	}
}

- (NSDictionary *)getSongInfo
{
	return [iTC getSongInfo];
}

@end
