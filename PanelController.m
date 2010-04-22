//
//  PanelController.m
//  Lyrics in Sight
//
//  Created by Michel Steuwer on 16.04.10.
//

#import "PanelController.h"
#import "AppController.h"
#import "AbstractNotifier.h"
#import "NotifierFactory.h"
#import "FormulaParser.h"


@implementation PanelController

@synthesize type;

#pragma mark initialize and set up methods
- (id)initWithController:(AppController *)aController andType:(NSString *)aType;
{
	if (![super initWithWindowNibName:@"Panel"])
		return nil;
	controller = aController;
	
	[self setShouldCascadeWindows:NO];
	rect = NSMakeRect(500, 500, 500, 300); // defaults
	type = aType;
	formula = @"Edit this text";
	inEditMode = FALSE;
	
	notifier = [NotifierFactory getNotifierForPanelController:self];
	[notifier registerPanelController:self];
	
	return self;
}

#pragma mark  converting the content stored in NSUserDefualts to and from a dictionary
- (id)initWithController:(AppController *)aController andDictionary:(NSDictionary *)aDictionary;
{
	if (![self initWithController:aController andType:[aDictionary objectForKey:@"Type"]])
		return nil;
	formula           = [aDictionary objectForKey:@"Formula"];
	rect.origin.x			= [[aDictionary objectForKey:@"X"] floatValue];
	rect.origin.y			= [[aDictionary objectForKey:@"Y"] floatValue];
	rect.size.width		= [[aDictionary objectForKey:@"Width"] floatValue];
	rect.size.height	= [[aDictionary objectForKey:@"Height"] floatValue];
	return self;
}

- (NSDictionary *)dictionary
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:type forKey:@"Type"];
	[dictionary setObject:formula forKey:@"Formula"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.origin.x] forKey:@"X"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.origin.y] forKey:@"Y"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.size.width] forKey:@"Width"];
	[dictionary setObject:[NSNumber numberWithFloat:rect.size.height] forKey:@"Height"];
	return dictionary;
}

#pragma mark  panel content management methods
- (void)update:(NSDictionary *)userInfo
{
	if (inEditMode) {
		return;
	}
	
	if (userInfo == nil) {
		[textView setString:@""];
		return;
	}
	
	FormulaParser *parser = [[FormulaParser alloc] initWithDictionary:userInfo];
	[textView setString:[parser evaluateFormula:formula]];
}

#pragma mark  edit mode management methods
- (void)editModeStarted
{
	inEditMode = TRUE;
	
	[self setEditable:YES];
	
	[textView setString:formula];
}

- (void)editModeStopped
{
	inEditMode = FALSE;
	
	// set variables, so that they can be stored in user defaults
	formula = [[textView string] copy]; // copy formula back
	rect = [[self window] frame];
	
	[self setEditable:NO];
	
	[notifier requestUpdate:self];			// update after finished editing
}

- (void)setEditable:(BOOL)newState
{
	[[self window] setMovable:newState];
	if (newState) {
		[[self window] setStyleMask:[[self window] styleMask] | NSClosableWindowMask | NSResizableWindowMask | NSTitledWindowMask | NSUtilityWindowMask];
	} else	{
		// remove closeable and resizable from the mask
		[[self window] setStyleMask:[[self window] styleMask] & ~NSClosableWindowMask & ~NSResizableWindowMask & ~NSTitledWindowMask & ~NSUtilityWindowMask];
	}
	[textView setEditable:newState];
	[textView setSelectable:newState];
	if (!newState) {
		[textView updateInsertionPointStateAndRestartTimer:NO]; // delete cursor (insertion Point)
	}
}

#pragma mark NSWindow delegate methods
-(void)windowDidLoad
{
	[[self window] setLevel:kCGDesktopIconWindowLevel];
	[[self window] setFrame:rect display:YES animate:YES];
	[self setEditable:NO];
	
	[textView setTextColor:[NSColor whiteColor]];
	
	[notifier requestUpdate:self];
	
	[[self window] display];
}

- (void)windowWillClose:(NSNotification *)notification
{
	[notifier unregisterPanelController:self];
	[controller removePanel:self];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"PanelController: type = '%@', formula = '%@', x = %f, y = %f, width = %f, height = %f", 
					type, formula, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

@end
