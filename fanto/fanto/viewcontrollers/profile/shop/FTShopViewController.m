//
//  FTShopViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShopViewController.h"
#import "FTShopItemCell.h"
#import "MItem.h"

@interface FTShopViewController () {
  NSMutableArray *_itemsData;
}

@end

@implementation FTShopViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customTitleWithText:@"Cửa hàng" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"Quay lại" color:[UIColor blackColor] target:self action:@selector(goBack) distance:-10];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customBarButtonWithImage:@"img-money-icon" title:@"80" color:[UIColor blackColor] target:nil action:nil distance:10];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _itemsData = nil;
}

- (void)reloadContents {
  [_itemsData removeAllObjects];
  [_itemsData addObjectsFromArray:@[[MItem new], [MItem new], [MItem new]]];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FTShopItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FTShopItemCell class])];
  
  if (cell == nil)
    cell = [FTShopItemCell new];
  
  [cell updateCellWithData:_itemsData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [FTShopItemCell heightToFitWithData:_itemsData[indexPath.row]];
}

@end
