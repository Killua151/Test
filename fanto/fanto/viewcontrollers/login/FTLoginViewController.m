//
//  FTLoginViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FTAppDelegate.h"

@interface FTLoginViewController () {
  UIView *_currentFirstResponder;
}

@end

@implementation FTLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customTitleWithText:@"ĐĂNG NHẬP"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)gestureLayerDidTap {
  [_currentFirstResponder resignFirstResponder];
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (![self validateFields])
    return;
  
  [self gestureLayerDidTap];
}

- (IBAction)btnForgotPasswordPressed:(UIButton *)sender {
}

- (IBAction)btnFacebookPressed:(UIButton *)sender {
  FTAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  
  if (FBSession.activeSession.state == FBSessionStateOpen ||
      FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
    [FBSession.activeSession closeAndClearTokenInformation];
    return;
  }
  
  [FBSession
   openActiveSessionWithReadPermissions:@[@"public_profile"]
   allowLoginUI:YES
   completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
     [appDelegate sessionStateChanged:session state:state error:error];
   }];
}

- (IBAction)btnGooglePressed:(UIButton *)sender {
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
  return YES;
}

@end
