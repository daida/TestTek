//
//  SFTableViewCell.h
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employe.h"

@interface SFTableViewCell : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *email;

@property (strong, nonatomic) Employe *employe;

+ (SFTableViewCell *)cellWithEmploye:(Employe *)pEmploye;

+ (CGFloat)height;
+ (CGFloat)width;

- (void)configureWithEmploye:(Employe *)pEmploye;

@end
