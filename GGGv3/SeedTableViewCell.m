//
//  SeedTableViewCell.m
//  GGGv3
//
//  Created by ray on 15/4/9.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "SeedTableViewCell.h"


static NSArray* g_iconImageFilenames = nil;

@implementation SeedTableViewCell

@synthesize icon;
@synthesize seedName;

- (void)awakeFromNib {
    // Initialization code
    if (g_iconImageFilenames == nil) {
        g_iconImageFilenames = [[NSArray alloc] initWithObjects:@"wealthIcon", @"healthIcon", @"wisdomIcon", @"harmoniousIcon", nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setIconImg:(NSInteger)index {
    NSInteger idx = index % [g_iconImageFilenames count];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:g_iconImageFilenames[idx] ofType:@"png"];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:imagePath];

    [self.icon setImage:img];
}

@end
