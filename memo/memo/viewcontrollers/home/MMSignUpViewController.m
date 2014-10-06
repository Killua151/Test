//
//  FTSignUpViewController.m
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSignUpViewController.h"
#import "FTSkillsListViewController.h"
#import "MUser.h"

@interface MMSignUpViewController () {
  UIView *_currentFirstResponder;
}

- (void)setupViews;
- (BOOL)validateFields;

@end

@implementation MMSignUpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self customTitleWithText:NSLocalizedString(@"Sign up", nil) color:UIColorFromRGB(51, 51, 51)];
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
  
#if kTestSignUp
//  _txtFullName.text = @"Test Account";
//  _txtEmail.text = @"test@accou.nt";
//  _txtUsername.text = @"test_account";
//  _txtPassword.text = @"asdfasdf";
//  _txtConfirmPassword.text = @"asdfasdf";
#endif
}

- (void)gestureLayerDidTap {
  [_currentFirstResponder resignFirstResponder];
  
  if (!DeviceScreenIsRetina4Inch())
    [self animateSlideViewUp:NO withDistance:0];
}

- (void)beforeGoBack {
  [_currentFirstResponder resignFirstResponder];
}

- (IBAction)btnSignUpPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
  
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [[MMServerHelper sharedHelper]
   signUpWithFullName:_txtFullName.text
   email:_txtEmail.text
   username:_txtUsername.text
   password:_txtPassword.text
   completion:^(NSDictionary *userData, NSError *error) {
     [Utils hideAllHUDsForView:self.navigationController.view];
     ShowAlertWithError(error);
     
     [Utils updateSavedUserWithAttributes:userData];
     [MUser loadCurrentUserFromUserDef];
     [self transitToViewController:[FTSkillsListViewController navigationController]];
   }];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
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

#pragma mark - Private methods
- (void)setupViews {
  _vTextFields.layer.cornerRadius = 4;
  _vTextFields.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vTextFields.layer.borderWidth = 1;
  
  _txtFullName.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtFullName.placeholder = NSLocalizedString(@"Full name (optional)", nil);
  
  _txtEmail.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtEmail.placeholder = NSLocalizedString(@"Email", nil);
  
  _txtUsername.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtUsername.placeholder = NSLocalizedString(@"Username", nil);
  
  _txtPassword.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtPassword.placeholder = NSLocalizedString(@"Password", nil);
  
  _txtConfirmPassword.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtConfirmPassword.placeholder = NSLocalizedString(@"Confirm password", nil);
  
  _btnSignUp.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSignUp.layer.cornerRadius = 4;
  [_btnSignUp setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
}

- (BOOL)validateFields {
//  if (![Utils validateBlank:_txtFullName.text]) {
//    [_txtFullName becomeFirstResponder];
//    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your full name", nil)];
//    return NO;
//  }
  
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
  
  if (![Utils validateBlank:_txtConfirmPassword.text]) {
    [_txtConfirmPassword becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Please enter your password again", nil)];
    return NO;
  }
  
  if (_txtPassword.text.length < 8) {
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Password must be at least 8 characters long", nil)];
    return NO;
  }
  
  if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
    _txtPassword.text = @"";
    _txtConfirmPassword.text = @"";
    [_txtPassword becomeFirstResponder];
    [Utils showToastWithMessage:NSLocalizedString(@"Passwords not match", nil)];
    return NO;
  }
  
  return YES;
}

@end