//
//  FTSignUpViewController.m
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSignUpViewController.h"
#import "MMSkillsListViewController.h"
#import "MUser.h"

@interface MMSignUpViewController ()

@end

@implementation MMSignUpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self customTitleWithText:MMLocalizedString(@"Sign up") color:UIColorFromRGB(51, 51, 51)];
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  _txtFullName.text = @"";
  _txtEmail.text = @"";
  _txtUsername.text = @"";
  _txtPassword.text = @"";
  _txtConfirmPassword.text = @"";
}

- (void)gestureLayerDidTap {
  [_currentFirstResponder resignFirstResponder];
  
  if (!DeviceScreenIsRetina4Inch())
    [self animateSlideViewUp:NO withDistance:0];
}

- (void)beforeGoBack {
  [_currentFirstResponder resignFirstResponder];
}

- (void)setupViews {
  _vTextFields.layer.cornerRadius = 4;
  _vTextFields.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vTextFields.layer.borderWidth = 1;
  
  _txtFullName.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtFullName.placeholder = MMLocalizedString(@"Full name (optional)");
  
  _txtEmail.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtEmail.placeholder = MMLocalizedString(@"Email");
  
  _txtUsername.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtUsername.placeholder = MMLocalizedString(@"Username");
  
  _txtPassword.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtPassword.placeholder = MMLocalizedString(@"Password");
  
  _txtConfirmPassword.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtConfirmPassword.placeholder = MMLocalizedString(@"Confirm password");
  
  _btnSignUp.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSignUp.layer.cornerRadius = 4;
  [_btnSignUp setTitle:MMLocalizedString(@"Sign up") forState:UIControlStateNormal];
  
  _btnFacebook.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnFacebook.layer.cornerRadius = 4;
  
  _btnGoogle.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnGoogle.layer.cornerRadius = 4;
}

- (BOOL)validateFields {
  if (![_txtEmail.text validateBlank]) {
    [_txtEmail becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Please enter your email")];
    return NO;
  }
  
  if (![_txtEmail.text validateEmail]) {
    [_txtEmail becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Invalid email")];
    return NO;
  }
  
  if (![_txtUsername.text validateBlank]) {
    [_txtUsername becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Please enter your username")];
    return NO;
  }
  
  if (![_txtPassword.text validateBlank]) {
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Please enter your password")];
    return NO;
  }
  
  if (![_txtConfirmPassword.text validateBlank]) {
    [_txtConfirmPassword becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Please confirm your password")];
    return NO;
  }
  
  if (_txtPassword.text.length < 8) {
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:
     [NSString stringWithFormat:MMLocalizedString(@"Password must be at least %d characters long"), 8]];
    return NO;
  }
  
  if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
    _txtPassword.text = @"";
    _txtConfirmPassword.text = @"";
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:MMLocalizedString(@"Passwords not match")];
    return NO;
  }
  
  return YES;
}

- (IBAction)btnSignUpPressed:(UIButton *)sender {
  [Utils logAnalyticsForButton:@"sign up"];
  
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
  
  ShowHudForCurrentView();
  
  [[MMServerHelper defaultHelper]
   signUpWithFullName:_txtFullName.text
   email:_txtEmail.text
   username:_txtUsername.text
   password:_txtPassword.text
   completion:^(NSDictionary *userData, NSError *error) {
     [self handleLoginResponseWithUserData:userData orError:error];
   }];
}

- (IBAction)btnFacebookPressed:(UIButton *)sender {
  [Utils logAnalyticsForButton:@"sign up with Facebook"];
  [self loginWithFacebook];
}

- (IBAction)btnGooglePressed:(UIButton *)sender {
  [Utils logAnalyticsForButton:@"sign up with Google+"];
  [self loginWithGoogle];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if (textField == _txtFullName)
    [Utils logAnalyticsForFocusTextField:@"sign up full name"];
  else if (textField == _txtEmail)
    [Utils logAnalyticsForFocusTextField:@"sign up email"];
  else if (textField == _txtUsername)
    [Utils logAnalyticsForFocusTextField:@"sign up username"];
  else if (textField == _txtPassword)
    [Utils logAnalyticsForFocusTextField:@"sign up password"];
  else
    [Utils logAnalyticsForFocusTextField:@"sign up confirm password"];
  
  _currentFirstResponder = textField;
  [self gestureLayerDidEnterEditingMode];
  
  if (!DeviceScreenIsRetina4Inch())
    [self animateSlideViewUp:YES withDistance:20];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == _txtFullName)
    [_txtEmail becomeFirstResponder];
  else if (textField == _txtEmail)
    [_txtUsername becomeFirstResponder];
  else if (textField == _txtUsername)
    [_txtPassword becomeFirstResponder];
  else if (textField == _txtPassword)
    [_txtConfirmPassword becomeFirstResponder];
  else
    [self btnSignUpPressed:nil];
  
  return YES;
}

@end
