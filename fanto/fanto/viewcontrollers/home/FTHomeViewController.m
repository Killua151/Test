//
//  FTHomeViewController.m
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHomeViewController.h"
#import "FTLoginViewController.h"
#import "FTSignUpViewController.h"

@interface FTHomeViewController () {
  FTLoginViewController *_loginVC;
  FTSignUpViewController *_signUpVC;
}

- (void)setupViews;

@end

@implementation FTHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customTitleWithText:@"" color:[UIColor clearColor]];
  
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  _loginVC = nil;
  _signUpVC = nil;
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (_loginVC == nil)
    _loginVC = [FTLoginViewController new];
  
  [self.navigationController pushViewController:_loginVC animated:YES];
  [_loginVC reloadContents];
}

- (IBAction)btnSignUpPressed:(UIButton *)sender {
  if (_signUpVC == nil)
    _signUpVC = [FTSignUpViewController new];

  [self.navigationController pushViewController:_signUpVC animated:YES];
  [_signUpVC reloadContents];
}

#pragma mark - Private methods
- (void)setupViews {
  if (DeviceScreenIsRetina4Inch())
    _imgBg.image = [UIImage imageNamed:@"Default-568h"];
  
  _btnLogIn.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogIn.layer.cornerRadius = 2;
  [_btnLogIn setTitle:NSLocalizedString(@"Log in", nil) forState:UIControlStateNormal];
  
  _btnSignUp.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSignUp.layer.cornerRadius = 2;
  [_btnSignUp setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
}

@end
