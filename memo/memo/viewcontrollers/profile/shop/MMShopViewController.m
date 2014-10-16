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
#import "MUser.h"

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
  
  ShowHudForCurrentView();
  [[MMServerHelper sharedHelper] getShopItems:^(NSInteger virtualMoney, NSArray *items, NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    [MUser currentUser].virtual_money = virtualMoney;
    [self styleMoneyBalanceLabel];
    
    [_itemsData removeAllObjects];
    
    for (MItem *item in items) {
      if (![_itemsData containsObject:item.section])
        [_itemsData addObject:item.section];
      
      [_itemsData addObject:item];
    }
    
    [_tblItems reloadData];
  }];
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
  
  if (cell == nil) {
    cell = [cellKlass new];
    
    if ([cell isKindOfClass:[MMShopItemCell class]])
      ((MMShopItemCell *)cell).delegate = self;
  }
  
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

#pragma mark - MMShopDelegate methods
- (void)shopDidBuyItem:(NSString *)itemId {
  ShowHudForCurrentView();
  
  [[MMServerHelper sharedHelper] buyItem:itemId completion:^(NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    [self reloadContents];
  }];
}

#pragma mark - Private methods
- (void)setupViews {
  _tblItems.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
  _lblMoneyBalanceInfo.font = [UIFont fontWithName:@"ClearSans" size:17];
}

- (void)styleMoneyBalanceLabel {
  NSString *styledString = [NSString stringWithFormat:@"%d", [MUser currentUser].virtual_money];
  NSString *message = [NSString stringWithFormat:MMLocalizedString(@"You have %@ MemoCoin"), styledString];
  
  [_lblMoneyBalanceInfo applyAttributedText:message
                                   onString:styledString
                             withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17]}];
}

@end
