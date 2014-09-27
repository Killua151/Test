//
//  FTJudgeOptionCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTJudgeOptionCell.h"

@implementation FTJudgeOptionCell

- (id)init {
  if (self = [super init]) {
    _vOptionBg.layer.cornerRadius = 3;
    _vOptionBg.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
    _vOptionBg.layer.borderWidth = 1;
    _lblOption.font = [UIFont fontWithName:@"ClearSans" size:17];
  }
  
  return self;
}

- (void)updateCellWithData:(NSString *)data {
  _lblOption.text = data;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  _vOptionBg.backgroundColor = selected ? UIColorFromRGB(129, 12, 21) : [UIColor whiteColor];
  _vOptionBg.layer.borderWidth = selected ? 0 : 1;
  _imgCheckbox.image = [UIImage imageNamed:
                        [NSString stringWithFormat:@"img-lessons_learning-checkbox-%@.png",
                         selected ? @"checked" : @"empty"]];
  _lblOption.textColor = selected ? [UIColor whiteColor] : UIColorFromRGB(102, 102, 102);
}

@end