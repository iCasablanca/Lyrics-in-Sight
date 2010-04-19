//
//  NotifierFactory.h
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 19.04.10.
//

#import <Cocoa/Cocoa.h>
@class PanelController;
@class AbstractNotifier;


@interface NotifierFactory : NSObject {

}

+ (AbstractNotifier *)getNotifierForPanelController:(PanelController *)aController;
+ (NSArray *)validTypes;

@end
