//
//  UIColor+more.m
//  MomiLoop
//
//  Created by Ashik Ahmad on 1/2/13.
//  Copyright (c) 2013 WNeeds. All rights reserved.
//

#import "UIColor+AKExtra.h"

NSString * const AKUIColorFailingStringKey = @"FailingString";
NSInteger  const AKUIColorErrorCodeBadFormat = 101;

NSString * const AKUIColorErrorDomain = @"UIColor+AKExtra";
NSString * const AKUIColorErrorMessageBadFormat = @"ERROR-BAD FORMAT: can not parse supplied string as color!\nCheck documentation for supported formats";

NSString * const AKUIColorHexRegex = @"\\b(0X|#)?([0-9A-F]{3,4}|[0-9A-F]{6}|[0-9A-F]{8})\\b";


@implementation UIColor (AKExtra)

+(UIColor *)colorWithR:(int)r g:(int)g b:(int)b a:(int) a{
    return [UIColor colorWithRed:r/255.0
                           green:g/255.0
                            blue:b/255.0
                           alpha:a/100.0];
}

-(UIColor *)withAlpha:(CGFloat)alpha {
    return [self colorWithAlphaComponent:alpha];
}

+(UIColor *)colorWithHexString:(NSString *)hex {
    return [self colorWithHexString:hex error:nil];
}

+(UIColor *)colorWithHexString:(NSString *)hex error:(NSError **) outError {
    // 1. Make trimmed & uppercase to reduce required condtions
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 2. Check if input is valid before start parsing
    NSRange validRange = [cString rangeOfString:AKUIColorHexRegex options:NSRegularExpressionSearch];
    if (validRange.location == NSNotFound) {
        if (outError) {
            *outError = [NSError errorWithDomain:AKUIColorErrorDomain
                                            code:AKUIColorErrorCodeBadFormat
                                        userInfo:@{
                                                   NSLocalizedDescriptionKey : AKUIColorErrorMessageBadFormat,
                                                   AKUIColorFailingStringKey : hex
                                                   }];
        }
        return nil;
    }
    // If it is not whole but have a parsable part, consider it.
    else if( !(validRange.location == 0 || validRange.length == cString.length) ){
        cString = [cString substringWithRange:validRange];
    }
    
    // 3. Strip 0x or # if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    // 4. Make it double if input is with single charecters for color
    if (cString.length <= 4) {
        NSMutableString *str = [@"" mutableCopy];
        for (int i=0; i<cString.length; i++) {
            char c = [cString characterAtIndex:i];
            [str appendFormat:@"%c%c", c, c];
        }
        cString = [str copy];
    }
    
    unsigned long long rgbNum = 0;
    [[NSScanner scannerWithString:cString] scanHexLongLong:&rgbNum];
    
    if(cString.length == 6)
        return UIColorFromRGB((UInt32)rgbNum);
    else
        return UIColorFromRGBA((UInt32)rgbNum);
}

@end

#pragma mark - C-Type Utils

/**
 @example UIColorFromRGB(0x00FF00) for green
 */
UIColor *UIColorFromRGB(UInt32 rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

UIColor *UIColorFromRGBA(UInt32 rgbaValue) {
    return [UIColor colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24))/255.0f green:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbaValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbaValue & 0xFF))/255.0];
}
