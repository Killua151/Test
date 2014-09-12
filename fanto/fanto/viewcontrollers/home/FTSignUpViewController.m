//
//  FTSignUpViewController.m
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSignUpViewController.h"

@interface FTSignUpViewController () {
  UIView *_currentFirstResponder;
}

- (BOOL)validateFields;

@end

@implementation FTSignUpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButton];
  [self customTitleWithText:@"Đăng ký"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  _txtFullName.text = @"";
  _txtEmail.text = @"";
  _txtUsername.text = @"";
  _txtPassword.text = @"";
}

- (void)gestureLayerDidTap {
  [_currentFirstResponder resignFirstResponder];
}

- (void)beforeGoBack {
  [_currentFirstResponder resignFirstResponder];
}

- (IBAction)btnSignUpPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  _currentFirstResponder = textField;
  [self gestureLayerDidEnterEdittingMode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == _txtFullName)
    [_txtEmail becomeFirstResponder];
  else if (textField == _txtEmail)
    [_txtUsername becomeFirstResponder];
  else if (textField == _txtUsername)
    [_txtPassword becomeFirstResponder];
  else
    [self btnSignUpPressed:nil];
  
  return YES;
}

#pragma mark - Private methods
- (BOOL)validateFields {
  if (![Utils validateBlank:_txtFullName.text]) {
    [_txtFullName becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your full name", nil)];
    return NO;
  }
  
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
  
  if (![Utils validateBlank:_txtUsername.text]) {
    [_txtUsername becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your username", nil)];
    return NO;
  }
  
  if (![Utils validateBlank:_txtPassword.text]) {
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your password", nil)];
    return NO;
  }
  
  if (_txtPassword.text.length < 8) {
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Password must be at least 8 characters long", nil)];
    return NO;
  }
  
  return YES;
}

@end
