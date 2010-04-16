//
//  PanelController.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>


@interface PanelController : NSWindowController {
	IBOutlet NSTextView *textView;
}

- (void)clear;

- (void)update:(NSDictionary *)songInfo;

@end
