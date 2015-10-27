//
//  Employe.h
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employe : NSObject <NSCoding> 

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *picture;

@end
