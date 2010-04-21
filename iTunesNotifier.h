//
//  iTunesNotifier.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import <Cocoa/Cocoa.h>
#import "AbstractNotifier.h"
@class iTunesApplication;
@class iTunesTrack;


@interface iTunesNotifier : AbstractNotifier {
	iTunesApplication *iTunes;
	NSMutableDictionary *userInfo; // to cash song infos
	NSCharacterSet* whitespaceCharacters;
}

- (id) init;
+ (iTunesNotifier *)instance;

- (void)songChanged:(NSNotification *)aNotification;
- (NSString *)lyricsOfTrack:(iTunesTrack *)track;

@end
