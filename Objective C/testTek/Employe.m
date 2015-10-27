//
//  Employe.m
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "Employe.h"

@implementation Employe

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.job = [aDecoder decodeObjectForKey:@"job"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.picture = [aDecoder decodeObjectForKey:@"picture"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.job forKey:@"job"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.picture forKey:@"picture"];
}

@end
