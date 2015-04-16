//
//  SeedEditorViewController.m
//  GGGv3
//
//  Created by ray on 15/4/15.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "SeedEditorViewController.h"
#import "SqliteMgr.h"

@interface SeedEditorViewController ()

@end

@implementation SeedEditorViewController

@synthesize seedName;
@synthesize positive;
@synthesize negative;
@synthesize iWant;
@synthesize isPublic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    positive.delegate = self;
    negative.delegate = self;
    iWant.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}



-(IBAction)onCommit:(id)sender {
    NSString* p = [positive text];
    NSString* n = [negative text];
    NSString* i = [iWant text];
    if ([p length] == 0) {
        UIAlertView *mBoxView = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedString(@"AddContentError", nil)
                                 message:NSLocalizedString(@"NoPositive", nil)
                                 delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                 otherButtonTitles:nil, nil];
        [mBoxView show];
        
        return;
    }
    if ([n length] == 0) {
        UIAlertView *mBoxView = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedString(@"AddContentError", nil)
                                 message:NSLocalizedString(@"NoNegative", nil)
                                 delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                 otherButtonTitles:nil, nil];
        [mBoxView show];
        return;
    }
    if ([i length] == 0) {
        UIAlertView *mBoxView = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedString(@"AddContentError", nil)
                                 message:NSLocalizedString(@"NoIWant", nil)
                                 delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                 otherButtonTitles:nil, nil];
        [mBoxView show];
        return;
    }
    
    if (![SqliteMgr.instance saveSeed:seedName positive:p negative:n iWant:i isPublic:self.isPublic.on]) {
        UIAlertView *mBoxView = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedString(@"AddContentError", nil)
                                 message:NSLocalizedString(@"CannotSaveContent", nil)
                                 delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                 otherButtonTitles:nil, nil];
        [mBoxView show];
        
        return;
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    switch (textField.tag) {
        case 0:
            [negative becomeFirstResponder];
            break;
        case 1:
            [iWant becomeFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}


@end
