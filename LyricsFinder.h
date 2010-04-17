//
//  LyricsFinder.h
//  Lyrics
//
//  Created by Sebastian Albers on 17.04.10.
//

#import <Cocoa/Cocoa.h>


@interface LyricsFinder : NSObject {

}

+(NSString *) findLyricsOf:(NSString *)title by:(NSString *)artist;

@end
