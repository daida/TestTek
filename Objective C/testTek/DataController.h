//
//  DataController.h
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DataControllerModelListCompletionBlock)(NSArray *employeList, NSError *error);
typedef void (^DataControllerImageCompletionBlock)(UIImage *image, NSError *error);

@interface DataController : NSObject

+ (instancetype)sharedInstance;

- (void)fetchJsonWithCompletionBlock:(DataControllerModelListCompletionBlock)pCompletionBlock;
- (void)fetchImageWithURL:(NSString *)pURL AndCompletionBlock:(DataControllerImageCompletionBlock)pCompletionBlock;

@end
