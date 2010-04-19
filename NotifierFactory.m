//
//  NotifierFactory.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 19.04.10.
//

#import "NotifierFactory.h"
#import "PanelController.h"
#import "AbstractNotifier.h"

// import custom notifiers
#import "iTunesNotifier.h"

#define I_TUNES	@"iTunes"
#define DATE		@"Date"


@implementation NotifierFactory

+ (AbstractNotifier *)getNotifierForPanelController:(PanelController *)aController;
{
	NSString *type = [aController type];
	NSAssert([[NotifierFactory validTypes] containsObject:type], @"Invalid type: %@.", type);
	
	if ([type isEqualToString:I_TUNES]) {
		return [iTunesNotifier instance];
	} else if ([type isEqualToString:DATE]) {
		NSLog(@"Not implemented yet!");
		return nil;
	} else {
		NSAssert(FALSE, @"Creation for valid type '%@' not implemented.", type);
		return nil;
	}
}

+ (NSArray *)validTypes
{
	return [NSArray	arrayWithObjects:I_TUNES, DATE, nil];
}

@end
