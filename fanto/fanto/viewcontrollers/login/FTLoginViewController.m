//
//  FTLoginViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLoginViewController.h"

@interface FTLoginViewController () {
  UIView *_currentFirstResponder;
}

@end

@implementation FTLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customTitleWithText:@"ĐĂNG NHẬP"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)gestureLayerDidTap {
  [_currentFirstResponder resignFirstResponder];
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
}

- (IBAction)btnForgotPasswordPressed:(UIButton *)sender {
}

- (IBAction)btnFacebookPressed:(UIButton *)sender {
}

- (IBAction)btnGooglePressed:(UIButton *)sender {
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  _currentFirstResponder = textField;
  [self gestureLayerDidEnterEdittingMode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == _txtUsername)
    [_txtPassword becomeFirstResponder];
  else if (textField == _txtPassword)
    [self btnLoginPressed:nil];
  
  return YES;
}

#pragma mark - Private methods
- (BOOL)validateFields {
  return YES;
}

@end
