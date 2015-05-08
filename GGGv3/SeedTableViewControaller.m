//
//  SeedTableViewControaller.m
//  GGGv3
//
//  Created by ray on 15/4/5.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "SeedTableViewControaller.h"
#import "SqliteMgr.h"
#import "SeedTableViewCell.h"
#import "SeedEditorViewController.h"

@implementation SeedTableViewControaller

@synthesize seeds;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.seeds = [SqliteMgr.instance getAllSeeds];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[SeedTableViewCell class]] &&
        [[segue destinationViewController] isKindOfClass:[SeedEditorViewController class]]) {
        SeedTableViewCell* tvc = sender;
        SeedEditorViewController* sevc = [segue destinationViewController];
        sevc.seedName = [tvc.seedName text];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (self.seeds) {
        count = [self.seeds count];
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SeedCellViewId";
    SeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SeedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    NSInteger idx = [indexPath item];
    [cell.seedName setText:self.seeds[idx]];
    [cell setIconImg:idx];
    return cell;
}


@end
