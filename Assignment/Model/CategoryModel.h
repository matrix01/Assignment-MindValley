//
//  CategoryModel.h
//  Assignment
//
//  Created by Milan Mia on 5/14/17.
//  Copyright © 2017 Milan Mia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface CategoryModel : JSONModel

@property(nonatomic, strong) NSDictionary *urls;
@property (nonatomic, strong) NSString *title;

@end
