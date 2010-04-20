//
//  FormulaParser.m
//  Lyrics in Sight
//
//  Created by Sebastian Albers on 20.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FormulaParser.h"


@implementation FormulaParser

- (id)initWithDictionary:(NSDictionary *)aDictionary
{
	if (![super init])
		return nil;
	
	dictionary = aDictionary;
	specialCharacters = [NSCharacterSet characterSetWithCharactersInString:@"<>{}[]|"];
	
	return self;
}

- (NSString *)evaluateNextAlternative:(NSString *)formula
{
	NSRange range = [formula rangeOfString:@"|"];
	if (range.location == NSNotFound) { // last alternative: return empty string
		return @"";
	}
	// alternative found -> evaluate
	return [self evaluateFormula:[formula substringFromIndex:range.location + 1]];
}

- (NSString *)evaluateFormula:(NSString *)formula
{
	NSMutableString *output = [NSMutableString string];
	NSRange range;
	
	while (TRUE) {
		
		if ([formula length] > 0 && [formula characterAtIndex:0] == '[') {
			range = [formula rangeOfString:@"]"];
			if (range.location == NSNotFound) {
				NSLog(@"Formula malformed: '[' without matching ']'");
				return @"";
			}
			
			// split
			NSString *condition = [formula substringWithRange:NSMakeRange(1, range.location - 1)];
			formula = [formula substringFromIndex:range.location + 1];
			
			// test condition
			if (![self evaluateCondition:condition]) {
				return [self evaluateNextAlternative:formula];
			}
		}
	
		range = [formula rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<{|"]];
		
		// no special characters found -> append remaining formula and return output
		if (range.location == NSNotFound) {
			[output appendString:formula];
			return output;
		}

		// split at speacial character (append string before, formula  = string after)
		[output appendString:[formula substringToIndex:range.location]];
		unichar ch = [formula characterAtIndex:range.location];
		formula = [formula substringFromIndex:range.location + 1];
		
		switch (ch) {
			case '<': // is token
				// search for matching closing character
				range = [formula rangeOfString:@">"];
				if (range.location == NSNotFound) {
					NSLog(@"Formula malformed: '<' without matching '>'");
					return @"";
				}
				
				// split at closing character (token = string before, formula = string after)
				NSString *token = [formula substringToIndex:range.location];
				formula = [formula substringFromIndex:range.location + 1];
				
				// evaluate token
				NSString *value = [self evaluateToken:token];
				if (value == nil) { // token evaluates to nil -> find next alternative
					return [self evaluateNextAlternative:formula];
				}
				// append evaluated token
				[output appendString:value];				
				break;
				
			case '{': // is subformula
				// search for (matching) closing character
				range = [formula rangeOfString:@"}"];
				if (range.location == NSNotFound) {
					NSLog(@"Formula malformed: '{' without matching '}'");
					return @"";
				}
				
				// split at first closing character
				NSString *part1;
				NSString *part2;
				NSString *part3 = [formula substringFromIndex:range.location + 1];
				NSString *temp  = @"{";
				temp = [temp stringByAppendingString:[formula substringToIndex:range.location]];  
				
				// search for matching openening character (may not be same as before)
				range = [temp rangeOfString:@"{" options:NSBackwardsSearch];
				NSAssert(range.location != NSNotFound, @"'{' not found");
				// split
				part1 = [temp substringToIndex:range.location];
				part2 = [temp substringFromIndex:range.location + 1];
				
				// append all first part, evaluated second part and third part
				formula = [[part1 stringByAppendingString:[self evaluateFormula:part2]] 
									 stringByAppendingString:part3];
				
				break;
				
			case '|': // current alternative was successfully evaluated -> stop parsing
				return output;
				
			default:
				NSLog(@"Invalid character found: %C", [formula characterAtIndex:range.location]);
				break;
		}
	}
}

- (NSString *)evaluateToken:(NSString *)token
{
	NSRange range = [token rangeOfCharacterFromSet:specialCharacters];
	if (range.location != NSNotFound) {
		NSLog(@"Malformed token: %@", token);
		return nil;
	}
	return [[dictionary objectForKey:token] description];
}

- (BOOL)evaluateCondition:(NSString *)condition
{
	// search for == operator
	NSRange range = [condition rangeOfString:@"=="];
	BOOL equal = TRUE;
	
	if (range.location == NSNotFound) {
		// search for != operator
		range = [condition rangeOfString:@"!="];
		equal = FALSE;
	}
	
	// error: no operator found
	if (range.location == NSNotFound) {
		NSLog(@"Condition malformed: neither == nor != found");
		return FALSE;
	}
	
	// split condition at operator
	NSString *first		= [condition substringToIndex:range.location];
	NSString *second	= [condition substringFromIndex:range.location + 2];
	
	// evaluate first operand
	if ([first length] > 0 && [first characterAtIndex:0] == '"' && [first characterAtIndex:[first length] - 1] == '"') {
		first = [first substringWithRange:NSMakeRange(1, [first length] - 2)];
	} else if ([first length] > 0 && [first characterAtIndex:0] == '<' && [first characterAtIndex:[first length] - 1] == '>') {
		first = [self evaluateToken:[first substringWithRange:NSMakeRange(1, [first length] - 2)]];
	} else {
		first = nil;
	}
	
	// evaluate second operand
	if ([second length] > 0 && [second characterAtIndex:0] == '"' && [second characterAtIndex:[second length] - 1] == '"') {
		second = [second substringWithRange:NSMakeRange(1, [second length] - 2)];
	} else if ([second length] > 0 && [second characterAtIndex:0] == '<' && [second characterAtIndex:[second length] - 1] == '>') {
		second = [self evaluateToken:[second substringWithRange:NSMakeRange(1, [second length] - 2)]];
	} else {
		second = nil;
	}
	
	// an operand was evaluated to nil -> return false
	if (first == nil || second == nil) {
		return FALSE;
	}
	
	// make string comparison
	BOOL result = [first isEqualToString:second];
	
	// return result depending on given operator
	if (equal) {
		return result;
	} else {
		return !result;
	}
}

@end
