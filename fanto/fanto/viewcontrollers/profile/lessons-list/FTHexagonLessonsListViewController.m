//
//  FTLessonsListViewController.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHexagonLessonsListViewController.h"

@interface FTHexagonLessonsListViewController ()

- (void)testOut;

@end

@implementation FTHexagonLessonsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customTitleWithText:@"Ngày và giờ" color:[UIColor whiteColor]];
  [self customBackButton];
  [self customBarButtonWithImage:nil title:@"Kiểm tra" color:[UIColor whiteColor] target:self action:@selector(testOut) distance:-8];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customNavBarBgWithColor:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Private methods
- (void)testOut {
}

@end
