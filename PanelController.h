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
- (id)initWithController:(AppController *)aController andType:(NSString *)aType;

// converting the content stored in NSUserDefualts to and from a dictionary
- (id)initWithController:(AppController *)aController andDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionary;

// panel content management methods
- (void)clear;
- (void)update:(NSDictionary *)userInfo;

// edit mode management methods
- (void)editModeStarted;
- (void)editModeStopped;

// NSWindow delegate methods
- (void)windowDidLoad;
- (void)windowDidMove:(NSNotification *)windowDidMoveNotification;
- (void)windowDidResize:(NSNotification *)windowDidResizeNotification;
- (void)windowWillClose:(NSNotification *)notification;

@end
