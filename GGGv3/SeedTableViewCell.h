//
//  SeedTableViewCell.h
//  GGGv3
//
//  Created by ray on 15/4/9.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeedTableViewCell : UITableViewCell


@property (readonly) IBOutlet UIImageView* icon;
@property (readonly) IBOutlet UILabel* seedName;

-(void)setIconImg:(NSInteger)index;

@end
