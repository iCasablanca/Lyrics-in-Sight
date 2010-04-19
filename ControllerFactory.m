//
//  ControllerFactory.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 19.04.10.
//

#import "ControllerFactory.h"


@implementation ControllerFactory

+ (void)registerPanelController:(PanelController *)aController
{
	
}

+ (NSArray *)validTypes
{
	return [NSArray	arrayWithObjects:@"iTunes", @"Date", nil];
}

@end
