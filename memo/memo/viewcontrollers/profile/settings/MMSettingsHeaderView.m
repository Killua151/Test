//
//  FTSettingsHeaderView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSettingsHeaderView.h"

@implementation MMSettingsHeaderView

- (id)init {
  if (self = [super init]) {
    _lblSectionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  }
  
  return self;
}

- (void)updateViewWithData:(NSString *)data {
  _lblSectionTitle.text = data;
  [_lblSectionTitle adjustToFitHeight];
}

- (CGFloat)heightToFit {
  return _lblSectionTitle.frame.origin.y + _lblSectionTitle.frame.size.height + 12;
}

@end
