//
//  AppDelegate.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"
#import "iTunesControl.h"

typedef enum {
	QUIT_LYRICS_IN_SIGHT_MENU_ITEM = 0,
	EDIT_MODE_MENU_ITEM = 1,
	ADD_PANEL_MENU_ITEM = 2
} MenuItems;

extern NSString * const LiSPanelCount;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	NSStatusItem *statusItem;
	
	iTunesControl *iTC;
	
	NSMutableArray *panelController;
	
	BOOL inEditMode;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)createMenu;
- (void)addPanel:(id)sender;
- (void)clearPanels;
- (void)updatePanels:(NSDictionary *)songInfo;
- (void)switchEditMode:(id)sender;
- (void)registeringUserDefaults;
- (void)creatingPanels;
- (NSInteger)panelCount;

- (NSDictionary *)getSongInfo;

@end
