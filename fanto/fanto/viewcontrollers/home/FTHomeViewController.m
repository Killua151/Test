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
  [self customNavigationBackgroundWithColor:nil];
  [self customTitleWithText:@""];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  _loginVC = nil;
  _signUpVC = nil;
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (_loginVC == nil)
    _loginVC = [FTLoginViewController new];
  
  [_loginVC reloadContents];
  [self.navigationController pushViewController:_loginVC animated:YES];
}

- (IBAction)btnSignUpPressed:(UIButton *)sender {
  if (_signUpVC == nil)
    _signUpVC = [FTSignUpViewController new];

  [_signUpVC reloadContents];
  [self.navigationController pushViewController:_signUpVC animated:YES];
}

@end
