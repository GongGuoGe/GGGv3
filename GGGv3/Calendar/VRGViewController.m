//
//  VRGViewController.m
//  Vurig Calendar
//
//  Created by in 't Veen Tjeerd on 5/29/12.
//  Copyright (c) 2012 Vurig. All rights reserved.
//

#import "VRGViewController.h"
#import "NSDate+convenience.h"
#import "SqliteMgr.h"

@interface VRGViewController ()

@end

@implementation VRGViewController
@synthesize contents;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    VRGCalendarView *calendar = [[[VRGCalendarView alloc] initWithFrame:CGRectMake((rectNav.size.width - kVRGCalendarViewWidth) * 0.5, rectNav.size.height + rect.size.height, kVRGCalendarViewWidth, 0)] init];

    calendar.delegate=self;
    [self.view addSubview:calendar];
    
    self.contents = [SqliteMgr.instance getAllContent];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSInteger)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    NSMutableArray* dates = [[NSMutableArray alloc] init];
    for (NSDictionary* cont in self.contents){
        NSDate* date = (NSDate*)[cont objectForKey:@"createTime"];
        if (month == [date month]) {
            [dates addObject:[NSNumber numberWithInteger:[date day]]];
        }
    }
    [calendarView markDates:dates];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}



- (void)viewDidUnload
{
    self.contents = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
