//
//  AppDelegate.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "AppController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	AppController *controller;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

@end
