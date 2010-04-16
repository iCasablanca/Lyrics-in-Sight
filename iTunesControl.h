//
//  iTunesControl.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"


@interface iTunesControl : NSObject {
	IBOutlet NSTextView *textView;
	iTunesApplication *iTunes;
}

-(id) init;

-(void) songChanged:(NSNotification *) aNotification;

@end
