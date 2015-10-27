//
//  SFTableViewLayout.h
//  testTek
//
//  Created by Nicolas Bellon on 09/09/2015.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SFTableViewCell;
@class SFTableViewCell;

FOUNDATION_EXTERN const NSString *kAllConstraints;
FOUNDATION_EXTERN const NSString *kTopConstraint;
FOUNDATION_EXTERN const NSString *kBottomConstraint;

@interface SFTableViewLayout : NSObject

+ (NSDictionary *)constraintWithCell:(SFTableViewCell *)pCell;

+ (NSArray *)scrollConstraintsWithScrollView:(UIScrollView *)pScrollView;

+ (NSDictionary *)moovingConstraintWithCell:(SFTableViewCell *)pCell;

@end
