//
//  PanelController.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
@class AppDelegate;

@interface PanelController : NSWindowController <NSCoding> {
	AppDelegate *controller;
	IBOutlet NSTextView *textView;
	
	NSRect rect;
}

- (id)init;
- (id)initWithController:(AppDelegate *)aController;
- (void)setController:(AppDelegate *)aController;

- (void)clear;
- (void)update:(NSDictionary *)songInfo;

- (void)editModeStarted;
- (void)editModeStoped;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
