//
//  FTForgotPasswordViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/11/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMForgotPasswordViewController.h"

@interface MMForgotPasswordViewController ()

- (void)setupViews;
- (BOOL)validateFields;

@end

@implementation MMForgotPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self customTitleWithText:MMLocalizedString(@"Forgot password") color:UIColorFromRGB(51, 51, 51)];
  [self setupViews];
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
  [self gestureLayerDidEnterEditingMode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self btnSubmitPressed:nil];
  return YES;
}

#pragma mark - Private methods
- (void)setupViews {
  _lblInstructions.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblInstructions.text = MMLocalizedString(@"Chúng tôi sẽ gửi cho bạn hướng dẫn lấy lại mật khẩu qua email");
  
  _vTextField.layer.cornerRadius = 4;
  _vTextField.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vTextField.layer.borderWidth = 1;
  
  _txtEmail.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtEmail.placeholder = MMLocalizedString(@"Email address");
  
  _btnSubmit.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSubmit.layer.cornerRadius = 4;
  [_btnSubmit setTitle:MMLocalizedString(@"Submit") forState:UIControlStateNormal];
}

- (BOOL)validateFields {
  if (![Utils validateBlank:_txtEmail.text]) {
    [_txtEmail becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Please enter your email")];
    return NO;
  }
  
  if (![Utils validateEmail:_txtEmail.text]) {
    [_txtEmail becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Invalid email")];
    return NO;
  }
  
  return YES;
}

@end
