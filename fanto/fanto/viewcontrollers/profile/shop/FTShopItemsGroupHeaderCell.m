//
//  FTShopItemsGroupHeaderCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShopItemsGroupHeaderCell.h"

@implementation FTShopItemsGroupHeaderCell

- (id)init {
  if (self = [super init]) {
    _lblItemGroupsName.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  }
  
  return self;
}

- (void)updateCellWithData:(NSString *)data {
  _lblItemGroupsName.text = data;
  [Utils adjustLabelToFitHeight:_lblItemGroupsName];
}

- (CGFloat)heightToFit {
  return _lblItemGroupsName.frame.origin.y + _lblItemGroupsName.frame.size.height + 12;
}

@end
