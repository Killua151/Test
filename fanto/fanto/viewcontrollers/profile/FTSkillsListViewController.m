//
//  FTSkillsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillsListViewController.h"

@interface FTSkillsListViewController ()

- (void)gotoProfile;
- (void)gotoShop;

@end

@implementation FTSkillsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:@"Tiếng Anh" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"Thông tin" target:self action:@selector(gotoProfile) distance:8];
  [self customBarButtonWithImage:nil title:@"Cửa hàng" target:self action:@selector(gotoShop) distance:-8];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Private methods
- (void)gotoProfile {
}

- (void)gotoShop {
}

@end
