//
//  FTShopViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShopViewController.h"

@interface FTShopViewController ()

@end

@implementation FTShopViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customTitleWithText:@"Cửa hàng" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"80" color:[UIColor blackColor] target:nil action:nil distance:8];
  [self customBarButtonWithImage:nil title:@"Quay lại" color:[UIColor blackColor] target:self action:@selector(goBack) distance:-10];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
