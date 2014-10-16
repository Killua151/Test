//
//  FTShopItemCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMShopItemCell.h"
#import "MItem.h"

@interface MMShopItemCell () {
  MItem *_itemData;
}

@end

@implementation MMShopItemCell

- (id)init {
  if (self = [super init]) {
    _lblItemName.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
    _lblItemDescription.font = [UIFont fontWithName:@"ClearSans" size:14];
    _btnPrice.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:14];
    _btnPrice.titleLabel.minimumScaleFactor = 11.0/_btnPrice.titleLabel.font.pointSize;
    _btnPrice.layer.cornerRadius = 4;
  }
  
  return self;
}

- (void)updateCellWithData:(MItem *)data {
  _itemData = data;
  
  _imgItemIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-item_icon-%@", _itemData._id]];
  
  _lblItemName.text = _itemData.name;
  [_lblItemName adjustToFitHeight];
  
  _lblItemDescription.text = _itemData.info;
  [_lblItemDescription adjustToFitHeightAndRelatedTo:_lblItemName withDistance:10];
  
  _btnPrice.enabled = _itemData.can_buy;
  
  if (_itemData.can_buy)
    _btnPrice.backgroundColor = UIColorFromRGB(129, 12, 21);
  else
    _btnPrice.backgroundColor = UIColorFromRGB(153, 153, 153);
  
  if (_itemData.consumable || _itemData.can_buy)
    [_btnPrice setTitle:[NSString stringWithFormat:MMLocalizedString(@"%d MemoCoin"), _itemData.price]
               forState:UIControlStateNormal];
  else
    [_btnPrice setTitle:_itemData.can_not_buy_message forState:UIControlStateNormal];
  
  [Utils adjustButtonToFitWidth:_btnPrice padding:16 constrainsToWidth:210];
}

- (CGFloat)heightToFit {
  return _lblItemDescription.frame.origin.y + _lblItemDescription.frame.size.height + 42;
}

- (IBAction)btnPricePressed:(UIButton *)sender {
  if (!_itemData.can_buy) {
    [Utils showToastWithMessage:_itemData.can_not_buy_message];
    return;
  }
  
  if ([_delegate respondsToSelector:@selector(shopDidBuyItem:)])
    [_delegate shopDidBuyItem:_itemData._id];
}

@end
