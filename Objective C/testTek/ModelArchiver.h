//
//  ModelArchiver.h
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelArchiver : NSObject

- (NSArray *)unarchiveEmployeList;
- (void)archiveEmployeList:(NSArray *)pEmployeList;

@end
