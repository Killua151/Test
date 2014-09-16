//
//  FTShopSectionView.m
//  fanto
//
//  Created by Ethan on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShopSectionView.h"

@interface FTShopSectionView ()

@end

@implementation FTShopSectionView

- (void)updateViewWithData:(NSString *)data {
  _lblSectionName.text = data;
  [Utils adjustLabelToFitHeight:_lblSectionName];
}

- (CGFloat)heightToFit {
  return _lblSectionName.frame.origin.y + _lblSectionName.frame.size.height + 12;
}

@end
