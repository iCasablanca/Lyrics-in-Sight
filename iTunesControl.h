//
//  ITunesControl.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"
@class AppDelegate;


@interface iTunesControl : NSObject {
	iTunesApplication *iTunes;
	AppDelegate *controller;
	NSMutableDictionary *songInfo; // to cash song infos
}

-(id) initWithController:(AppDelegate *)aController;
-(void) songChanged:(NSNotification *) aNotification;
-(NSDictionary *)getSongInfo;

@end
