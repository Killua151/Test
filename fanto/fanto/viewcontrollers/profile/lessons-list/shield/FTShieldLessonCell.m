//
//  FTShieldLessonCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShieldLessonCell.h"

@implementation FTShieldLessonCell

- (id)init {
  if (self = [super init]) {
  }
  
  return self;
}

- (void)updateCellWithData:(MLesson *)data {
  CGRect frame = _vLesson.frame;
  frame.origin.y = DeviceScreenIsRetina4Inch() ? -54 : -10;
  _vLesson.frame = frame;
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_lblLessonTitle.text];
  [attributedText addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17]}
                          range:NSMakeRange(0, 3)];

  _lblLessonTitle.attributedText = attributedText;
}

- (IBAction)btnRetakePressed:(UIButton *)sender {
  DLog(@"invoke");
}

@end
