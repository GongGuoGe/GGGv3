//
//  SeedEditorViewController.h
//  GGGv3
//
//  Created by ray on 15/4/15.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeedEditorViewController : UIViewController<UITextFieldDelegate>

@property (retain) NSString* seedName;
@property (readonly) IBOutlet UITextField* positive;
@property (readonly) IBOutlet UITextField* negative;
@property (readonly) IBOutlet UITextField* iWant;
@property (readonly) IBOutlet UISwitch* isPublic;


@end
