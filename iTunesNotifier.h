//
//  iTunesNotifier.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "AbstractNotifier.h"
@class iTunesApplication;


@interface iTunesNotifier : AbstractNotifier {
	iTunesApplication *iTunes;
	NSMutableDictionary *userInfo; // to cash song infos
}

-(id) init;
-(void) songChanged:(NSNotification *) aNotification;

+ (iTunesNotifier *)instance;

@end
