//
//  FormulaParser.h
//  Lyrics in Sight
//
//  Created by Sebastian Albers on 20.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FormulaParser : NSObject {
	NSDictionary *dictionary;
	NSCharacterSet *specialCharacters;
	NSCharacterSet *openingCharacters;
	NSCharacterSet *closingCharacters;
}

- (id)initWithDictionary:(NSDictionary *)aDictionary;

- (NSString *)evaluateFormula:(NSString *)formula;
- (NSString *)evaluateToken:(NSString *)token;

@end
