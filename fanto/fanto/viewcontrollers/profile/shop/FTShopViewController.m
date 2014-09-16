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
  [self customBarButtonWithImage:nil title:@"Quay lại" color:[UIColor blackColor] target:self action:@selector(goBack) distance:-10];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customBarButtonWithImage:@"img-money-icon" title:@"80" color:[UIColor blackColor] target:nil action:nil distance:10];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 0;
}

@end
