//
//  PanelController.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
@class AppDelegate;

@interface PanelController : NSWindowController {
	AppDelegate *controller;
	IBOutlet NSTextView *textView;
}

- (id)initWithController:(AppDelegate *)aController;

- (void)clear;
- (void)update:(NSDictionary *)songInfo;

- (void)editModeStarted;
- (void)editModeStoped;

@end
