//
//  AKAttributedStringKit.h
//  Looptivity-v2
//
//  Created by Ashik Ahmad on 11/1/14.
//  Copyright (c) 2014 WNeeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AKAttributeKit : NSObject
+(NSMutableAttributedString *) parsedString:(NSString *) text;
@end

@interface NSString (AKAttributeKit)
-(NSMutableAttributedString *)parseAttributes;
@end