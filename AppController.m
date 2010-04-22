//
//  AppController.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 18.04.10.
//

#import "AppController.h"
#import "iTunesNotifier.h"
#import "PanelController.h"
#import "NotifierFactory.h"


@implementation AppController

#pragma mark initialize methods
- (id)init
{
	if (![super init])
		return nil;
	inEditMode = FALSE;
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
	for (NSString *type in [NotifierFactory validTypes]) {
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
NSString * const LiSPanelControllers = @"PanelControllers";

- (void)registerUserDefaults
{
	// inititalize default user defaults
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

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
		[self setEditMode:NO];
	} else { // switch to edit mode
		[self	setEditMode:YES];
	}
}

- (void)setEditMode:(BOOL)setToEditMode
{
	if (inEditMode == setToEditMode)
		return;
	if (setToEditMode) {
		for (PanelController *controller in panelControllers) {
			[controller editModeStarted];
		}
		[[[statusItem menu] itemWithTag:EDIT_MODE_MENU_ITEM] setState:NSOnState];
		inEditMode = YES;
	} else {
		for (PanelController *controller in panelControllers) {
			[controller editModeStopped];
		}
		[[[statusItem menu] itemWithTag:EDIT_MODE_MENU_ITEM] setState:NSOffState];
		[self saveUserDefaults]; // save user defaults after finished edit mode
		inEditMode = NO;
	}
}

#pragma mark panel management
- (void)addPanel:(id)sender
{
	PanelController *controller = [[PanelController alloc] initWithController:self
																																		andType:[sender title]];
	[panelControllers addObject:controller];
	
	[controller showWindow:self];
	
	if (!inEditMode) { // switch to edit mode after adding panel
		[self switchEditMode:self];
	} else {
		[controller editModeStarted]; // if in edit mode, set added panel also to edit mode
	}
	
	// save change to user defaults
	[self saveUserDefaults];
}

- (void)removePanel:(PanelController *)aController
{
	[panelControllers removeObject:aController];
	
	// save change to user defaults
	[self saveUserDefaults];
}

@end
