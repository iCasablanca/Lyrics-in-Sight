//
//  AppController.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 18.04.10.
//

#import <Cocoa/Cocoa.h>
#import "iTunesControl.h"
#import "PanelController.h"

typedef enum {
	QUIT_LYRICS_IN_SIGHT_MENU_ITEM = 0,
	EDIT_MODE_MENU_ITEM = 1,
	ADD_PANEL_MENU_ITEM = 2
} MenuItems;

extern NSString * const LiSPanelCount;
extern NSString * const LiSPanelControllers;

@interface AppController : NSObject {
	NSStatusItem *statusItem;
	
	iTunesControl *iTC;
	
	BOOL inEditMode;
	
	// data to be saved in NSUserDefaults
	NSInteger panelCount;
	NSMutableArray *panelController;
}

// start up methods
- (void)createStatusItem;
- (void)createPanels;

// user default management
- (void)registerUserDefaults;
- (void)loadUserDefaults;
- (void)saveUserDefaults;

// trigger edit mode
- (void)switchEditMode:(id)sender;

// panel management
- (void)addPanel:(id)sender;
- (void)removePanel:(PanelController *)aController;

// panel content management
- (void)clearPanels;
- (void)updatePanels:(NSDictionary *)songInfo;
- (NSDictionary *)getSongInfo;

@end
