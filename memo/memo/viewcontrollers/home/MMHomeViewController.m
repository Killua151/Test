//
//  FTHomeViewController.m
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHomeViewController.h"
#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMCoursesListViewController.h"

@interface MMHomeViewController () {
  MMLoginViewController *_loginVC;
  MMSignUpViewController *_signUpVC;
  MMCoursesListViewController *_coursesListVC;
}

- (void)setupViews;

@end

@implementation MMHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customTitleWithText:@"" color:[UIColor clearColor]];
  
  [self setupViews];
  [self test];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  _loginVC = nil;
  _signUpVC = nil;
  _coursesListVC = nil;
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (_loginVC == nil)
    _loginVC = [MMLoginViewController new];
  
  [self.navigationController pushViewController:_loginVC animated:YES];
  [_loginVC reloadContents];
}

- (IBAction)btnNewUserPressed:(UIButton *)sender {
#if kTestSignUp
  if (_signUpVC == nil)
    _signUpVC = [MMSignUpViewController new];

  [self.navigationController pushViewController:_signUpVC animated:YES];
  [_signUpVC reloadContents];
#else
  if (_coursesListVC == nil)
    _coursesListVC = [FTCoursesListViewController new];
  
  [self.navigationController pushViewController:_coursesListVC animated:YES];
  [_coursesListVC reloadContents];
#endif
}

#pragma mark - Private methods
- (void)setupViews {
  if (DeviceScreenIsRetina4Inch())
    _imgBg.image = [UIImage imageNamed:@"Default-568h"];
  
  _btnLogIn.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogIn.layer.cornerRadius = 4;
  [_btnLogIn setTitle:MMLocalizedString(@"Log in") forState:UIControlStateNormal];
  
  _btnNewUser.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNewUser.layer.cornerRadius = 4;
  [_btnNewUser setTitle:MMLocalizedString(@"New user") forState:UIControlStateNormal];
}

- (void)test {
  
}

@end
