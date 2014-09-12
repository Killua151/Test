//
//  FTForgotPasswordViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/11/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTForgotPasswordViewController.h"

@interface FTForgotPasswordViewController ()

- (BOOL)validateFields;

@end

@implementation FTForgotPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButton];
  [self customTitleWithText:@"Quên mật khẩu"];
}

- (void)reloadContents {
  _txtEmail.text = @"";
}

- (void)gestureLayerDidTap {
  [_txtEmail resignFirstResponder];
}

- (void)beforeGoBack {
  [_txtEmail resignFirstResponder];
}

- (IBAction)btnSubmitPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self gestureLayerDidEnterEdittingMode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self btnSubmitPressed:nil];
  return YES;
}

#pragma mark - Private methods
- (BOOL)validateFields {
  if (![Utils validateBlank:_txtEmail.text]) {
    [_txtEmail becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your email", nil)];
    return NO;
  }
  
  if (![Utils validateEmail:_txtEmail.text]) {
    [_txtEmail becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Invalid email", nil)];
    return NO;
  }
  
  return YES;
}

@end
