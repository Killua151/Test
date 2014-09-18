//
//  FTLoginViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLoginViewController.h"
#import "FTAppDelegate.h"
#import "FTForgotPasswordViewController.h"
#import "FTSkillsListViewController.h"

@interface FTLoginViewController () {
  UIView *_currentFirstResponder;
  FTForgotPasswordViewController *_forgotPasswordVC;
}

- (BOOL)validateFields;

@end

@implementation FTLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButton];
  [self customTitleWithText:@"Đăng nhập" color:UIColorFromRGB(153, 153, 153)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  _txtUsername.text = @"";
  _txtPassword.text = @"";
}

- (void)gestureLayerDidTap {
  [_currentFirstResponder resignFirstResponder];
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
  
  UINavigationController *skillsListNavigation = [FTSkillsListViewController navigationController];
  skillsListNavigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  
  [self.navigationController presentViewController:skillsListNavigation animated:YES completion:^{
    FTAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = skillsListNavigation;
  }];
}

- (IBAction)btnForgotPasswordPressed:(UIButton *)sender {
  if (_forgotPasswordVC == nil)
    _forgotPasswordVC = [FTForgotPasswordViewController new];
  
  [self.navigationController pushViewController:_forgotPasswordVC animated:YES];
  [_forgotPasswordVC reloadContents];
}

- (IBAction)btnFacebookPressed:(UIButton *)sender {
  [Utils logInFacebookFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    DLog(@"%@ %@", userData, error);
  }];
}

- (IBAction)btnGooglePressed:(UIButton *)sender {
  [Utils logInGoogleFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    DLog(@"%@ %@", userData, error);
  }];
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
  if (![Utils validateBlank:_txtUsername.text]) {
    [_txtUsername becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your username", nil)];
    return NO;
  }
  
  if (![Utils validateAlphaNumeric:_txtUsername.text]) {
    [_txtUsername becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Username must contain alphanumeric only", nil)];
    return NO;
  }
  
  if (![Utils validateBlank:_txtPassword.text]) {
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your password", nil)];
    return NO;
  }
  
  return YES;
}

@end
