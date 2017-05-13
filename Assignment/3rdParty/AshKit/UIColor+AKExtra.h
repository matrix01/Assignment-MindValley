//
//  UIColor+More.h
//  ViewDecor
//
//  Created by Ashik Ahmad on 2/4/13.
//  Copyright (c) 2013 Ashik Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const AKUIColorFailingStringKey;
UIKIT_EXTERN NSInteger  const AKUIColorErrorCodeBadFormat;

@interface UIColor (AKExtra)

/**
 @param r : red value   (0-255)
 @param g : green value (0-255)
 @param b : blue value  (0-255)
 @param a : alpha value (0-100)
 @return generated UIColor
 */
+(UIColor *) colorWithR:(int) r g:(int) g b:(int) b a:(int) a;

/**
 @note just a shortcut for colorWithAlphaComponent:
 */
-(UIColor *) withAlpha:(CGFloat) alpha;

/**
 @param hex : hexadecimal representation of color.
 @note Supported formats: case-insensitive formats with any of this patterns with or without 0x or # prefix - rrggbb, rrggbbaa, rgb, rgba
 @return Generated UIColor if parsed successfully, nil otherwise.
 */
+(UIColor *) colorWithHexString:(NSString *) hex;

/**
 @param hex : hexadecimal representation of color.
 @param outError : if parse failed, error will be stored here if available.
 @note Supported formats: case-insensitive formats with any of this patterns with or without 0x or # prefix - rrggbb, rrggbbaa, rgb, rgba
 @return Generated UIColor if parsed successfully, nil otherwise.
 */
+(UIColor *)colorWithHexString:(NSString *)hex error:(NSError **) outError;

@end

#pragma C-Type Utils

/**
 @param rgbValue : use hexadecimal in a pattern like @c 0xRRGGBB
 @note Example: for green, use @c UIColorFromRGB(0x00FF00)
 */
UIColor *UIColorFromRGB(UInt32 rgbValue);

/**
 @param rgbaValue : use hexadecimal in a pattern like @c 0xRRGGBBAA.
 
 @note Example: for green, use @c UIColorFromRGB(0x00FF0FF)
 */
UIColor *UIColorFromRGBA(UInt32 rgbaValue);
