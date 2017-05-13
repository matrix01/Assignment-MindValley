//
//  NSString+Trim.h
//  WNImageFacoryTest
//
//  Created by Ashik Ahmad on 11/22/13.
//  Copyright (c) 2013 Ashik. All rights reserved.
//

#import <Foundation/Foundation.h>  

#ifndef NSStringFromProperty
#define NSStringFromProperty(property) NSStringFromSelector(@selector(property))
#endif

@interface NSString (AshKit)

// General
+(BOOL)isVisibleString:(NSString *) string;

-(NSString *)trim;
-(BOOL)contains:(NSString *) substring;

// Validation
-(BOOL) isValidEmail;
-(BOOL) validateUsingRegex:(NSString *) regex;
-(BOOL) validateUsingRegexes:(NSArray *) regexes;

// Encryption
- (NSString*)MD5;

@end
