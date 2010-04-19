//
//  AbstractNotifier.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 19.04.10.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"


@interface AbstractNotifier : NSObject {
	NSMutableArray *panelControllers;
}

- (void)registerPanelController:(PanelController *)aController;
- (void)unregisterPanelController:(PanelController *)aController;

- (void)requestUpdate:(PanelController *)aController;

@end
