//
//  SFTableViewDelegate.h
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFTableView;
@class SFTableViewCell;

@protocol SFTableViewDelegate <NSObject>

- (SFTableViewCell *)tableView:(SFTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableView:(SFTableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
