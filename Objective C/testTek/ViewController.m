//
//  ViewController.m
//  testTek
//
//  Created by applecaca on 09/09/15.
//  Copyright © 2015 stupeflix. All rights reserved.
//

#import "ViewController.h"
#import "DataController.h"
#import "SFTableView.h"
#import "SFTableViewCell.h"
#import "SFTableViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSArray *employeList;
@property (weak, nonatomic) IBOutlet SFTableView *tableView;


@end

@implementation ViewController

#pragma mark View life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    
    [[DataController sharedInstance] fetchJsonWithCompletionBlock:^(NSArray *pemployeList, NSError *error)
    {
        if (pemployeList && error == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.employeList = pemployeList;
                [self.spinner stopAnimating];
                [self.spinner setHidden:YES];
                self.tableView.delegate = self;
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SFTableViewDelegate

- (SFTableViewCell *)tableView:(SFTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.employeList != nil)
    {
        return [SFTableViewCell cellWithEmploye:self.employeList[indexPath.row]];
    }
    return nil;
}

- (NSInteger)tableView:(SFTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.employeList == nil) return 0;
    
    return self.employeList.count;
}

@end
