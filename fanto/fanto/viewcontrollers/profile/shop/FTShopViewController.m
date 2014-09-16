//
//  FTShopViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShopViewController.h"
#import "FTShopItemCell.h"
#import "FTShopSectionView.h"
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
  
  _tblItems.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
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
  if (_itemsData == nil)
    _itemsData = [NSMutableArray new];
  
  [_itemsData removeAllObjects];
  [_itemsData addObjectsFromArray:@[
                                    @{
                                      @"title" : [@"Lorem ipsum dolor sit amet, consectetur adipiscing elit" uppercaseString],
                                      @"items" : @[[MItem new], [MItem new], [MItem new]]
                                      },
                                    @{
                                      @"title" : @"PRACTICE",
                                      @"items" : @[[MItem new], [MItem new], [MItem new], [MItem new]]
                                      },
                                    @{
                                      @"title" : @"TEST",
                                      @"items" : @[[MItem new]]
                                      }]];
  
  [_tblItems reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [_itemsData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_itemsData[section][@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FTShopItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FTShopItemCell class])];
  
  if (cell == nil)
    cell = [FTShopItemCell new];
  
  [cell updateCellWithData:_itemsData[indexPath.section][@"items"][indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [FTShopItemCell heightToFitWithData:_itemsData[indexPath.section][@"items"][indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  FTShopSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FTShopSectionView class])];
  
  if (view == nil)
    view = [FTShopSectionView new];
  
  [view updateViewWithData:_itemsData[section][@"title"]];
  
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return [FTShopSectionView heightToFithWithData:_itemsData[section][@"title"]];
}

@end
