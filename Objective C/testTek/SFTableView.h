//
//  SFTableView.h
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTableViewDelegate.h"

@interface SFTableView : UIView
@property (nonatomic, weak)   id<SFTableViewDelegate> delegate;
@end
