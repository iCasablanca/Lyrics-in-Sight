//
//  AbstractNotifier.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 19.04.10.
//

#import "AbstractNotifier.h"


@implementation AbstractNotifier

- (id)init
{
	if (![super init])
		return nil;
	panelControllers = [NSMutableArray array];
	return self;
}

- (void)registerPanelController:(PanelController *)aController
{
	[panelControllers addObject:aController];
}

- (void)unregisterPanelController:(PanelController *)aController
{
	[panelControllers removeObject:aController];
}

- (void)requestUpdate:(PanelController *)aController;
{
	NSAssert(FALSE, @"Method requestUpdate of abstract class AbstractNotifier called");
}

@end
