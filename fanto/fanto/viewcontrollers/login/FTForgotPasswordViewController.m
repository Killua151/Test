//
//  FTForgotPasswordViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/11/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTForgotPasswordViewController.h"

@interface FTForgotPasswordViewController ()

@end

@implementation FTForgotPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButton];
  [self customTitleWithText:@"Quên mật khẩu"];
}

- (void)gestureLayerDidTap {
  [_txtEmail resignFirstResponder];
}

- (void)beforeGoBack {
  [_txtEmail resignFirstResponder];
}

- (IBAction)btnSubmitPressed:(UIButton *)sender {
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self gestureLayerDidEnterEdittingMode];
}

@end
