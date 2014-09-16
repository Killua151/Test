//
//  FTShopItemCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShopItemCell.h"
#import "MItem.h"

@interface FTShopItemCell ()

- (void)applyEffectToPriceButton;

@end

@implementation FTShopItemCell

- (void)updateCellWithData:(MItem *)data {
  [Utils adjustLabelToFitHeight:_lblItemName];
  [Utils adjustLabelToFitHeight:_lblItemDescription relatedTo:_lblItemName withDistance:10];
  
  [self applyEffectToPriceButton];
}

- (CGFloat)heightToFit {
  return _lblItemDescription.frame.origin.y + _lblItemDescription.frame.size.height + 42;
}

- (IBAction)btnPricePressed:(UIButton *)sender {
}

#pragma mark - Private methods
- (void)applyEffectToPriceButton {
  NSString *plainTitle = [_btnPrice titleForState:UIControlStateNormal];
  NSRange unitRange = NSMakeRange(plainTitle.length - 6, 6);
  NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:plainTitle];
  [attributedTitle addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]
                          range:unitRange];
  [attributedTitle addAttribute:NSForegroundColorAttributeName
                          value:[UIColor whiteColor]
                          range:NSMakeRange(0, plainTitle.length)];
  [_btnPrice setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

@end
