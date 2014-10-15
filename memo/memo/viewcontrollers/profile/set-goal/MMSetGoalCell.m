//
//  FTSetGoalCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSetGoalCell.h"

@implementation MMSetGoalCell

- (id)init {
  if (self = [super init]) {
    _lblTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
    _lblValue.font = [UIFont fontWithName:@"ClearSans" size:17];
  }
  
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  NSString *suffix = selected ? @"selected" : @"normal";
  _imgRadio.image = [UIImage imageNamed:[NSString stringWithFormat:@"img-set_goal-radio-%@.png", suffix]];
  _lblTitle.textColor = selected ? UIColorFromRGB(129, 12, 21) : UIColorFromRGB(102, 102, 102);
  _lblValue.textColor = selected ? UIColorFromRGB(129, 12, 21) : UIColorFromRGB(102, 102, 102);
}

- (void)updateCellWithData:(NSDictionary *)data {
  if (data == nil || ![data isKindOfClass:[NSDictionary class]])
    return;
  
  _lblTitle.text = data[@"title"];
  _lblValue.text = [NSString stringWithFormat:MMLocalizedString(@"%d EXP daily"), [data[@"value"] integerValue]];
  _lblValue.hidden = [data[@"value"] integerValue] <= 0;
}

@end
