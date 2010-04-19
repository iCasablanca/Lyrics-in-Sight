//
//  ControllerFactory.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 19.04.10.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"


@interface ControllerFactory : NSObject {

}

+ (void)registerPanelController:(PanelController *)aController;
+ (NSArray *)validTypes;

@end
