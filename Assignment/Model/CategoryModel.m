//
//  CategoryModel.m
//  Assignment
//
//  Created by Milan Mia on 5/14/17.
//  Copyright © 2017 Milan Mia. All rights reserved.
//

#import "CategoryModel.h"
#import "NSString+AshKit.h"

@implementation CategoryModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{
                                 @"title" : NSStringFromProperty(title),
                                 @"links" : NSStringFromProperty(urls),
                                 }];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
