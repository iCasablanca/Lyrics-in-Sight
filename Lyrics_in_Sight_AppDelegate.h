//
//  Lyrics_in_Sight_AppDelegate.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "iTunesControl.h"
#import "Menulet.h"

@interface Lyrics_in_Sight_AppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	IBOutlet iTunesControl *iTC;
}

@property (assign) IBOutlet NSWindow *window;

@end
