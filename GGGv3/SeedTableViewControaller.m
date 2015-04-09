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

@implementation SeedTableViewControaller

@synthesize seeds;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.seeds = [SqliteMgr.instance getAllSeeds];
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
    return cell;
}


@end
