//
//  PanelController.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
@class AppController;

@interface PanelController : NSWindowController {
	AppController *controller;
	IBOutlet NSTextView *textView;
	
	// data to be stored in NSUserDefaults see: encodeWithCoder / initWithCoder
	NSRect rect;
	NSString *type;
}

// initialize and set up methods
- (id)init;
- (id)initWithController:(AppController *)aController;
- (void)setController:(AppController *)aController;

// panel content management methods
- (void)clear;
- (void)update:(NSDictionary *)songInfo;

// edit mode management methods
- (void)editModeStarted;
- (void)editModeStopped;

// converting the content stored in NSUserDefualts to and from a dictionary
- (id)initWithDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionary;

// NSWindowController methods
- (void)windowDidLoad;
- (void)windowDidMove:(NSNotification *)windowDidMoveNotification;
- (void)windowDidResize:(NSNotification *)windowDidResizeNotification;

@end
