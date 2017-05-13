//
//  AKAttributedStringKit.m
//  Looptivity-v2
//
//  Created by Ashik Ahmad on 11/1/14.
//  Copyright (c) 2014 WNeeds. All rights reserved.
//

#import "AKAttributeKit.h"
#import "UIColor+AKExtra.h"
#import "NSString+AshKit.h"

static NSDictionary *__tags;

// ----------------------------------------------------------
#pragma mark - AKAttributeTag (Private) - Interface
// ----------------------------------------------------------

@interface AKAttributeTag : NSObject

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *params;
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, assign) NSInteger length;

-(id) initWithTag:(NSString *) tag params:(NSString *) params location:(NSInteger) location;
-(BOOL) isOpen;
-(BOOL) isEmpty;

@end

// ----------------------------------------------------------
#pragma mark - AKAttributeKit
// ----------------------------------------------------------

@implementation AKAttributeKit

+(NSMutableAttributedString *) parsedString:(NSString *) text {
    if (!__tags) {
        __tags = @{
                   @"bg"    : NSBackgroundColorAttributeName,
                   @"fg"    : NSForegroundColorAttributeName,
                   @"font"  : NSFontAttributeName,
                   @"s"     : NSStrikethroughStyleAttributeName,
                   @"u"     : NSUnderlineStyleAttributeName,
                   @"a"     : NSLinkAttributeName
                 };
    }
    
    NSMutableArray *tags = [NSMutableArray array];
    NSString *tagRegex = @"</?[a-zA-Z][^<>]*>";
    NSMutableString *formattingStr = [text mutableCopy];
    NSRange searchRange = NSMakeRange(0, formattingStr.length);
    
    NSRange tagRange;
    
    while ((tagRange = [formattingStr rangeOfString:tagRegex options:NSRegularExpressionSearch range:searchRange]).location != NSNotFound) {
        NSString *wholeTag = [formattingStr substringWithRange:tagRange];
        BOOL validTag = NO;
        
        if ([wholeTag hasPrefix:@"</"]) { // Closing Tag
            NSString *tag = [wholeTag substringWithRange:NSMakeRange(2, wholeTag.length-3)];
            NSInteger tagIndex = [self indexOfLatestOpenTagOfType: tag inQeue: tags];
            if (tagIndex != NSNotFound) {
                AKAttributeTag *startTag = (AKAttributeTag *)tags[tagIndex];
                startTag.length = tagRange.location - startTag.location;
                validTag = true;
            }
        } else { // Starting Tag
            NSString *tagWithParams = [wholeTag substringWithRange:NSMakeRange(1, wholeTag.length-2)];
            NSString *tag = [tagWithParams componentsSeparatedByString:@" "][0];
            if (__tags[tag]) {
                NSRange tagNameRange = [tagWithParams rangeOfString:tag];
                if (tagNameRange.location != NSNotFound)  {
                    NSString *params = [[tagWithParams stringByReplacingCharactersInRange:tagNameRange withString: @""] trim];
                    AKAttributeTag *attrTag = [[AKAttributeTag alloc] initWithTag:tag params:params location:tagRange.location];
                    [tags addObject:attrTag];
                    validTag = true;
                }
            }
        }
        
        if (validTag) {
            [formattingStr replaceCharactersInRange:tagRange withString:@""];
            searchRange = NSMakeRange(searchRange.location, formattingStr.length-searchRange.location);
        } else {
            NSInteger newLoc = tagRange.location + tagRange.length;
            searchRange = NSMakeRange(newLoc, formattingStr.length-newLoc);
        }
    }
    
    // Add attributes
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:formattingStr];
    for (NSInteger index = 0; index < tags.count; index++) {
        AKAttributeTag *attrTag = tags[index];
        if (![attrTag isEmpty]) {
            NSString *attrKey = __tags[attrTag.tag];
            if (attrKey) {
                NSObject *value = [self valueForAttribute:attrKey params: attrTag.params];
                if (value) {
                    NSRange range = NSMakeRange(attrTag.location, attrTag.length);
                    [attrStr addAttribute:attrKey value: value range: range];
                }
            }
        }
    }
    
    return attrStr;
}

+(NSInteger)indexOfLatestOpenTagOfType:(NSString *) type inQeue: (NSMutableArray *) qeue
{
    for (NSInteger index = qeue.count-1; index >= 0; index--){
        AKAttributeTag *attrTag = qeue[index];
        if([attrTag isOpen] && [attrTag.tag isEqualToString:type]) {
            return index;
        }
    }
    return NSNotFound;
}

+(NSObject *)valueForAttribute:(NSString *) attrName params:(NSString *) param
{
    if([attrName isEqualToString:NSBackgroundColorAttributeName]
       || [attrName isEqualToString:NSForegroundColorAttributeName]){
        return [self colorFromString:param];
    } else if([attrName isEqualToString:NSUnderlineStyleAttributeName]
              || [attrName isEqualToString:NSStrikethroughStyleAttributeName]) {
        return @([param integerValue]);
    } else if([attrName isEqualToString:NSFontAttributeName]){
        return [self fontFromString:param];
    } else if([attrName isEqualToString:NSLinkAttributeName]){
        return [NSURL URLWithString:param];
    } else {
        return nil;
    }
}

+(UIFont *)fontFromString:(NSString *)fontStr
{
    NSArray *components = [fontStr componentsSeparatedByString:@"|"];
    if( components.count >= 2) {
        NSString *fontName = [components[0] trim];
        NSInteger fontSize = [components[1] integerValue];
        return [UIFont fontWithName:fontName size:fontSize];
    }
    return nil;
}

+(UIColor *)colorFromString:(NSString *)colorStr
{
    NSArray *components = [colorStr componentsSeparatedByString:@"|"];
    if (components.count >= 3) {
        CGFloat r = [components[0] intValue]/255.0;
        CGFloat g = [components[1] intValue]/255.0;
        CGFloat b = [components[2] intValue]/255.0;
        CGFloat a = components.count >= 4 ? [components[3] intValue]/255.0 : 1.0;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    else if (components.count == 1) {
        return [UIColor colorWithHexString:components[0]];
    }
    return nil;
}

@end

// ----------------------------------------------------------
#pragma mark - AKAttributeTag (Private) - Implementation
// ----------------------------------------------------------

@implementation AKAttributeTag

-(id)initWithTag:(NSString *)tag params:(NSString *)params location:(NSInteger)location {
    if((self = [super init])){
        self.tag = tag;
        self.params = params;
        self.location = location;
        self.length = -1;
    }
    return self;
}

-(BOOL)isOpen {return self.length < 0;}
-(BOOL)isEmpty {return self.length<= 0;}

@end

@implementation NSString (AKAttributeKit)

-(NSMutableAttributedString *)parseAttributes {
    return [AKAttributeKit parsedString:self];
}

@end