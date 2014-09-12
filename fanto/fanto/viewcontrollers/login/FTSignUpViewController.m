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
  return YES;
}

@end
