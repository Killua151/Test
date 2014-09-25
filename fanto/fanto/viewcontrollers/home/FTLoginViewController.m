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

- (void)setupViews;
- (BOOL)validateFields;
- (void)goToSkillsList;

@end

@implementation FTLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self customTitleWithText:NSLocalizedString(@"Log in", nil) color:UIColorFromRGB(51, 51, 51)];
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

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
  
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [[FTServerHelper sharedHelper]
   logInWithUsername:_txtUsername.text
   password:_txtPassword.text
   completion:^(NSDictionary *userData, NSError *error) {
     [Utils hideAllHUDsForView:self.navigationController.view];
     ShowAlertWithError(error);
     
     DLog(@"%@", userData);
     [Utils updateSavedUserWithAttributes:@{
                                            kParamUsername : [Utils normalizeString:userData[kParamUsername]],
                                            kParamAuthToken : [Utils normalizeString:userData[kParamAuthToken]]
                                            }];
     [self goToSkillsList];
   }];
  
  return;
}

- (IBAction)btnForgotPasswordPressed:(UIButton *)sender {
  if (_forgotPasswordVC == nil)
    _forgotPasswordVC = [FTForgotPasswordViewController new];
  
  [self.navigationController pushViewController:_forgotPasswordVC animated:YES];
  [_forgotPasswordVC reloadContents];
}

- (IBAction)btnFacebookPressed:(UIButton *)sender {
  [Utils logInFacebookFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    ShowAlertWithError(error);
    
    [Utils showHUDForView:self.navigationController.view withText:nil];
    
    [[FTServerHelper sharedHelper]
     logInWithFacebookId:userData[kParamFbId]
     accessToken:userData[kParamFbAccessToken]
     completion:^(NSDictionary *userData, NSError *error) {
       [Utils hideAllHUDsForView:self.navigationController.view];
       ShowAlertWithError(error);
       
       DLog(@"%@", userData);
       [Utils updateSavedUserWithAttributes:userData];
       [self goToSkillsList];
     }];
  }];
}

- (IBAction)btnGooglePressed:(UIButton *)sender {
  [Utils logInGoogleFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    ShowAlertWithError(error);
    
    [Utils showHUDForView:self.navigationController.view withText:nil];
    
    [[FTServerHelper sharedHelper]
     logInWithGmail:userData[kParamGmail]
     accessToken:userData[kParamGAccessToken]
     completion:^(NSDictionary *userData, NSError *error) {
       [Utils hideAllHUDsForView:self.navigationController.view];
       ShowAlertWithError(error);
       
       DLog(@"%@", userData);
       [Utils updateSavedUserWithAttributes:userData];
       [self goToSkillsList];
     }];
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
- (void)setupViews {
  _vTextFields.layer.cornerRadius = 4;
  _vTextFields.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _vTextFields.layer.borderWidth = 1;
  
  _txtUsername.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtUsername.placeholder = NSLocalizedString(@"Username", nil);
  
  _txtPassword.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtPassword.placeholder = NSLocalizedString(@"Password", nil);
  
  _btnLogIn.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogIn.layer.cornerRadius = 4;
  [_btnLogIn setTitle:NSLocalizedString(@"Log in", nil) forState:UIControlStateNormal];
  
  _btnForgotPassword.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnForgotPassword setTitle:NSLocalizedString(@"Forgot password", nil) forState:UIControlStateNormal];
  
  _btnFacebook.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnFacebook.layer.cornerRadius = 4;
  
  _btnGoogle.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnGoogle.layer.cornerRadius = 4;
}

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

- (void)goToSkillsList {
  UINavigationController *skillsListNavigation = [FTSkillsListViewController navigationController];
  skillsListNavigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  
  [self.navigationController presentViewController:skillsListNavigation animated:YES completion:^{
    FTAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = skillsListNavigation;
  }];
}

@end
