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

@end

@implementation FTHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customTitleWithText:@"" color:[UIColor clearColor]];
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

@end
