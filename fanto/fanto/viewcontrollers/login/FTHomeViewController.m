//
//  FTHomeViewController.m
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHomeViewController.h"
#import "FTLoginViewController.h"

@interface FTHomeViewController () {
  FTLoginViewController *_loginVC;
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
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (_loginVC == nil)
    _loginVC = [FTLoginViewController new];
  
  [self.navigationController pushViewController:_loginVC animated:YES];
}

- (IBAction)btnSignUpPressed:(UIButton *)sender {
}

@end
