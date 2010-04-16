//
//  ITunesControl.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "ITunes.h"
@class AppDelegate;


@interface ITunesControl : NSObject {
	iTunesApplication *iTunes;
	AppDelegate *controller;
}

-(id) initWithController:(AppDelegate *)aController;

-(void) songChanged:(NSNotification *) aNotification;

@end
