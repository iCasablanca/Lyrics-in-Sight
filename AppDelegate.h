//
//  AppDelegate.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"
#import "ITunesControl.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	NSStatusItem *statusItem;
	ITunesControl *iTC;
	
	NSMutableArray *panelController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)createMenu;
- (void)loadPanels;
- (void)addPanel:(id)sender;
- (void)clearPanels;
- (void)updatePanels:(NSDictionary *)songInfo;


@end
