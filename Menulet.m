//
//  Menulet.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "Menulet.h"


@implementation Menulet

+ (void)showMenuIcon
{
	NSStatusItem *statusItem;
	NSMenu        *theMenu;
	statusItem = [[[NSStatusBar systemStatusBar] 
								 statusItemWithLength:NSVariableStatusItemLength]
								retain];
	[statusItem setImage:[NSImage imageNamed:@"menubaricon"]];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString 
												stringWithString:@""]]; 
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@""];
	
	theMenu = [[NSMenu alloc] initWithTitle:@""];
	[theMenu addItemWithTitle:@"Quit Lyrics in Sight" action:@selector(terminate:) keyEquivalent:@""];
	[statusItem setMenu:theMenu];
	[theMenu release];
}

@end
