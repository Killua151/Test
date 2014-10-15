//
//  FTShopViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMShopViewController.h"
#import "MMShopItemCell.h"
#import "MMShopItemsGroupHeaderCell.h"
#import "MItem.h"

@interface MMShopViewController () {
  NSMutableArray *_itemsData;
}

- (void)setupViews;
- (void)styleMoneyBalanceLabel;

@end

@implementation MMShopViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:MMLocalizedString(@"Memo Plaza") color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  [self customBarButtonWithImage:nil
                           title:MMLocalizedString(@"Close")
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(dismissViewController)
                        distance:-8];
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _itemsData = nil;
}

- (void)reloadContents {
  if (_itemsData == nil)
    _itemsData = [NSMutableArray new];
  
  [_itemsData removeAllObjects];
  [_itemsData addObjectsFromArray:
   @[
     [@"Lorem ipsum dolor sit amet, consectetur adipiscing elit" uppercaseString],
     [MItem new], [MItem new], [MItem new],
     @"PRACTICE",
     [MItem new], [MItem new], [MItem new], [MItem new],
     @"TEST",
     [MItem new]]];
  
  [self styleMoneyBalanceLabel];
  [_tblItems reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_itemsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  id data = _itemsData[indexPath.row];
  Class cellKlass = nil;
  
  if ([data isKindOfClass:[NSString class]])
    cellKlass = [MMShopItemsGroupHeaderCell class];
  else
    cellKlass = [MMShopItemCell class];
  
  BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellKlass)];
  
  if (cell == nil)
    cell = [cellKlass new];
  
  [cell updateCellWithData:data];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  id data = _itemsData[indexPath.row];
  
  if ([data isKindOfClass:[NSString class]])
    return [MMShopItemsGroupHeaderCell heightToFitWithData:data];
  
  return [MMShopItemCell heightToFitWithData:data];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return _vHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return _vHeader.frame.size.height;
}

#pragma mark - Private methods
- (void)setupViews {
  _tblItems.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
  _lblMoneyBalanceInfo.font = [UIFont fontWithName:@"ClearSans" size:17];
}

- (void)styleMoneyBalanceLabel {
  if (_lblMoneyBalanceInfo.text == nil)
    return;
  
  NSRange moneyBalanceRange = [_lblMoneyBalanceInfo.text rangeOfString:@"25"];
  
  if (moneyBalanceRange.location == NSNotFound)
    return;
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_lblMoneyBalanceInfo.text];
  [attributedText addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"ClearSans-Bold" size:17]
                         range:moneyBalanceRange];
  
  _lblMoneyBalanceInfo.attributedText = attributedText;
}

@end
