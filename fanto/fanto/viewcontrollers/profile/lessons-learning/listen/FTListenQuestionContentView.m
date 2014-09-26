//
//  FTListenQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTListenQuestionContentView.h"

@implementation FTListenQuestionContentView

- (void)setupViews {
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _imgAnswerFieldBg.image = [[UIImage imageNamed:@"img-popup-bg.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                             resizingMode:UIImageResizingModeStretch];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _vAnswerField.frame;
    frame.origin.y -= 20;
    _vAnswerField.frame = frame;
  }
}

@end
