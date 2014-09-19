//
//  FTForgotPasswordViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/11/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTForgotPasswordViewController.h"

@interface FTForgotPasswordViewController ()

- (void)setupViews;
- (BOOL)validateFields;

@end

@implementation FTForgotPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self customTitleWithText:NSLocalizedString(@"Forgot password", nil) color:UIColorFromRGB(51, 51, 51)];
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
  [self gestureLayerDidEnterEdittingMode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self btnSubmitPressed:nil];
  return YES;
}

#pragma mark - Private methods
- (void)setupViews {
  _lblInstructions.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblInstructions.text = NSLocalizedString(@"Chúng tôi sẽ gửi cho bạn hướng dẫn lấy lại mật khẩu qua email", nil);
  
  _vTextField.layer.cornerRadius = 4;
  _vTextField.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vTextField.layer.borderWidth = 1;
  
  _txtEmail.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtEmail.placeholder = NSLocalizedString(@"Email address", nil);
  
  _btnSubmit.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSubmit.layer.cornerRadius = 4;
  [_btnSubmit setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
}

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
