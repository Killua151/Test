//
//  FTLoginViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "FTAppDelegate.h"
#import "FTForgotPasswordViewController.h"

@interface FTLoginViewController () {
  UIView *_currentFirstResponder;
  FTForgotPasswordViewController *_forgotPasswordVC;
}

- (void)setupGoogleSignIn;
- (BOOL)validateFields;

@end

@implementation FTLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButton];
  [self customTitleWithText:@"Đăng nhập"];
  [self setupGoogleSignIn];
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
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnForgotPasswordPressed:(UIButton *)sender {
  if (_forgotPasswordVC == nil)
    _forgotPasswordVC = [FTForgotPasswordViewController new];
  
  [_forgotPasswordVC reloadContents];
  [self.navigationController pushViewController:_forgotPasswordVC animated:YES];
}

- (IBAction)btnFacebookPressed:(UIButton *)sender {
  FTAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  
  if (FBSession.activeSession.state == FBSessionStateOpen ||
      FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
    [FBSession.activeSession closeAndClearTokenInformation];
    return;
  }
  
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [FBSession
   openActiveSessionWithReadPermissions:@[@"public_profile"]
   allowLoginUI:YES
   completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
     BOOL result = [appDelegate sessionStateChanged:session state:state error:error];
     
     if (!result) {
       [Utils hideAllHUDsForView:self.navigationController.view];
       return;
     }
     
     DLog(@"%@", [FBSession activeSession]);
     
     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       [Utils hideAllHUDsForView:self.navigationController.view];
       DLog(@"%@", result);
     }];
   }];
}

- (IBAction)btnGooglePressed:(UIButton *)sender {
  [Utils showHUDForView:self.navigationController.view withText:nil];
  [[GPPSignIn sharedInstance] authenticate];
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

#pragma mark - GPPSignInDelegate methods
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
  [Utils hideAllHUDsForView:self.navigationController.view];
  DLog(@"%@ %@ %@", auth.properties, auth.userEmail, auth.userID);
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
  
  return YES;
}

- (void)setupGoogleSignIn {
  GPPSignIn *signIn = [GPPSignIn sharedInstance];
  
  signIn.shouldFetchGoogleUserEmail = YES;
  signIn.clientID = kGoogleSignInKey;
  signIn.scopes = @[@"profile"];
  signIn.delegate = self;
}

@end
