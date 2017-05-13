//
//  NSString+Trim.m
//  WNImageFacoryTest
//
//  Created by Ashik Ahmad on 11/22/13.
//  Copyright (c) 2013 Ashik. All rights reserved.
//

#import "NSString+AshKit.h"
#import <CommonCrypto/CommonDigest.h>

NSString *const kEmailRegex =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";


@implementation NSString (AshKit)

//------------------------------------------------------
#pragma mark - General
//------------------------------------------------------

+(BOOL)isVisibleString:(NSString *)string {
    if (string
        && [string isKindOfClass:[NSString class]]
        && [[string trim] length] > 0) {
        return YES;
    }
    return NO;
}

-(NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(BOOL)contains:(NSString *)substring {
    return ([self rangeOfString:substring].location != NSNotFound);
}

//------------------------------------------------------
#pragma mark - Validation
//------------------------------------------------------

-(BOOL) isValidEmail
{
    if([self length] < 3) return NO; // Quick reject: atleast it should have _@_
    return [self validateUsingRegex:kEmailRegex];
}

-(BOOL) validateUsingRegex:(NSString *) regex
{
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:self];
    return myStringMatchesRegEx;
}

-(BOOL) validateUsingRegexes:(NSArray *) regexes {
    for(NSString *regex in regexes){
        if(![self validateUsingRegex:regex]) return NO;
    }
    return YES;
}

//------------------------------------------------------
#pragma mark - Encryption
//------------------------------------------------------

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end

