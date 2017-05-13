//
//  ContentDwldMgr.h
//  Assignment
//
//  Created by Milan Mia on 5/13/17.
//  Copyright © 2017 Milan Mia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"

@interface ContentDwldMgr : NSObject {
    NSOperationQueue *loaderQ;
    NSMutableArray *imagesArray;
}

+(instancetype) sharedMgr;
-(NSArray*) getImagesArray;
@end
