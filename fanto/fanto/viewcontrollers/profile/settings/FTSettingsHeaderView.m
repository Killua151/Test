//
//  FTSettingsHeaderView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSettingsHeaderView.h"

@implementation FTSettingsHeaderView

- (id)init {
  if (self = [super init]) {
    _lblSectionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  }
  
  return self;
}

- (void)updateViewWithData:(NSString *)data {
  _lblSectionTitle.text = data;
  [Utils adjustLabelToFitHeight:_lblSectionTitle];
}

- (CGFloat)heightToFit {
  return _lblSectionTitle.frame.origin.y + _lblSectionTitle.frame.size.height + 12;
}

@end
