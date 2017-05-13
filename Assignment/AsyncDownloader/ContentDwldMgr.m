//
//  ContentDwldMgr.m
//  Assignment
//
//  Created by Milan Mia on 5/13/17.
//  Copyright © 2017 Milan Mia. All rights reserved.
//

#import "ContentDwldMgr.h"

static ContentDwldMgr* sharedMgr = nil;
@implementation ContentDwldMgr

+(instancetype) sharedMgr {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMgr = [[ContentDwldMgr alloc] initPrivate];
    });
    return sharedMgr;
}

-(instancetype)initPrivate{
    self =[super init];
    loaderQ = [NSOperationQueue new];
    imagesArray = [[NSMutableArray alloc] init];
    [self readJSON];
    return self;
}

-(NSArray *)getImagesArray {
    return [imagesArray mutableCopy];
}


-(void) readJSON {
    __block NSData *jsonData = nil;
    NSBlockOperation *operationBlock = [NSBlockOperation blockOperationWithBlock:^{
        jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:FILE_URL]];
    }];
    operationBlock.completionBlock = ^(void){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            NSLog(@"%@", [dic valueForKey:@"categories"]);
            NSArray *categoryArray = [CategoryModel arrayOfModelsFromDictionaries:dic];
            NSLog(@"%@", categoryArray);
        }];
    };
    [loaderQ addOperation:operationBlock];
}

-(void) downloadImageWithUrl:(NSURL*)url {
    __block NSData *imageData = nil;
    NSBlockOperation *operationBlock = [NSBlockOperation blockOperationWithBlock:^{
        imageData = [NSData dataWithContentsOfURL:url];
    }];
    operationBlock.completionBlock = ^(void){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [imagesArray addObject:imageData];
        }];
    };
    [loaderQ addOperation:operationBlock];
}

@end
