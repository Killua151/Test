//
//  FTLoginViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMLoginViewController.h"
#import "MMAppDelegate.h"
#import "MMForgotPasswordViewController.h"
#import "MMSkillsListViewController.h"
#import "MUser.h"

@interface MMLoginViewController () {
  MMForgotPasswordViewController *_forgotPasswordVC;
}

@end

@implementation MMLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self customTitleWithText:MMLocalizedString(@"Log in") color:UIColorFromRGB(51, 51, 51)];
  [self setupViews];
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

- (void)setupViews {
  _vTextFields.layer.cornerRadius = 4;
  _vTextFields.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vTextFields.layer.borderWidth = 1;
  
  _txtUsername.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtUsername.placeholder = MMLocalizedString(@"Username or email");
  
  _txtPassword.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtPassword.placeholder = MMLocalizedString(@"Password");
  
  _btnLogIn.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogIn.layer.cornerRadius = 4;
  [_btnLogIn setTitle:MMLocalizedString(@"Log in") forState:UIControlStateNormal];
  
  _btnForgotPassword.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnForgotPassword setTitle:MMLocalizedString(@"Forgot password") forState:UIControlStateNormal];
  
  _btnFacebook.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnFacebook.layer.cornerRadius = 4;
  
  _btnGoogle.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnGoogle.layer.cornerRadius = 4;
}

- (BOOL)validateFields {
  if (![_txtUsername.text validateBlank]) {
    [_txtUsername becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Please enter your username or email")];
    return NO;
  }
  
  if (![_txtPassword.text validateBlank]) {
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Please enter your password")];
    return NO;
  }
  
  return YES;
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
  
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper]
   logInWithUsername:_txtUsername.text
   password:_txtPassword.text
   completion:^(NSDictionary *userData, NSError *error) {
     [self handleLoginResponseWithUserData:userData orError:error];
   }];
  
  return;
}

- (IBAction)btnForgotPasswordPressed:(UIButton *)sender {
  if (_forgotPasswordVC == nil)
    _forgotPasswordVC = [MMForgotPasswordViewController new];
  
  [self.navigationController pushViewController:_forgotPasswordVC animated:YES];
  [_forgotPasswordVC reloadContents];
}

- (IBAction)btnFacebookPressed:(UIButton *)sender {
  [self loginWithFacebook];
}

- (IBAction)btnGooglePressed:(UIButton *)sender {
  [self loginWithGoogle];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  _currentFirstResponder = textField;
  [self gestureLayerDidEnterEditingMode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == _txtUsername)
    [_txtPassword becomeFirstResponder];
  else if (textField == _txtPassword)
    [self btnLoginPressed:nil];
  
  return YES;
}

@end
