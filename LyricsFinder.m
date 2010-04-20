//
//  LyricsFinder.m
//  Lyrics
//
//  Created by Sebastian Albers on 17.04.10.
//

#import "LyricsFinder.h"


@implementation LyricsFinder

/**
 * replace whitespaces by underscores and escape special URI characters
 */
+(NSString *) escapeUri:(NSString *)uri
{
	uri = [uri stringByReplacingOccurrencesOfString:@" "
																			 withString:@"_"];
	CFStringRef escapedURI = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
																																		(CFStringRef)uri, 
																																		NULL, 
																																		(CFStringRef)@";/?:@&=+$,", 
																																		kCFStringEncodingUTF8);
	return ((NSString *) escapedURI);
}

/**
 * create lyrics URL for given title and artist
 */
+(NSString *) createUrlFor:(NSString *)title by:(NSString *)artist
{
	NSString *url = @"http://lyrics.wikia.com/";
	url = [url stringByAppendingString:[LyricsFinder escapeUri:artist]];
	url = [url stringByAppendingString:@":"];
	url = [url stringByAppendingString:[LyricsFinder escapeUri:title]];
	return url;
}

/**
 * download lyrics from given URL. returns nil, if lyrics not found
 */
+(NSString *) downloadLyricsFrom:(NSString *)url
{
	//NSLog(@"downloading '%@'", url);
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	if (data == nil) {
		return nil;
	}
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data 
																												options:NSXMLDocumentTidyHTML 
																													error:nil];
	if (document == nil) {
		return nil;	
	}
	
	NSMutableArray *lyricLines = [[NSMutableArray alloc] init];
	NSString *content = [document stringValue];
	NSArray *lines = [content componentsSeparatedByString: @"\n"];
	
	NSString *line;
	NSEnumerator* iter = [lines objectEnumerator];
	BOOL isLyric = FALSE;
	BOOL firstLyricLine = FALSE;
	while (line = [iter nextObject]) {
		if ([line isEqualToString:@"You must enable javascript to view this page. This is a requirement of our licensing agreement with music Gracenote."]) {
			// last line before lyrics
			isLyric = TRUE;
			firstLyricLine = TRUE;
		} 
		else if ([line isEqualToString:@"<p>NewPP limit report"]) {
			// first line after lyrics
			isLyric = FALSE;			 
		}
		else if (isLyric) {
			if (firstLyricLine) { // remove ad from first line
				NSRange range = [line rangeOfString:@"Ringtone to your Cell "];
				if (range.location != NSNotFound) {
					line = [line substringFromIndex:(range.location + range.length)];
				}
				firstLyricLine = FALSE;
			}
			[lyricLines addObject:line]; // add line to array
		}
	}
	
	if ([lyricLines	count] == 0) {
		return nil;
	}
	
	return [lyricLines componentsJoinedByString:@"\n"];
}

/**
 * find lyrics for given title and artist. returns empty NSString, if lyrics not found
 */
+(NSString *) findLyricsOf:(NSString *)title by:(NSString *)artist
{
	if (title == nil || artist == nil) {
		return @"";
	}
	
	NSString *lyrics;
	NSString *url;
	
	// try do download lyrics using given title and artist
	url = [LyricsFinder createUrlFor:title by:artist];
	lyrics = [LyricsFinder downloadLyricsFrom:url];
	if (lyrics != nil)
		return lyrics;
	
	// try to download lyrics using given artist and capitalized title
	url = [LyricsFinder createUrlFor:[title capitalizedString] by:artist];
	lyrics = [LyricsFinder downloadLyricsFrom:url];
	if (lyrics != nil)
		return lyrics;

	return @"";
}

@end
