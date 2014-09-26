//
//  FTFormQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTFormQuestionContentView.h"

@interface FTFormQuestionContentView ()

@end

@implementation FTFormQuestionContentView

- (void)setupViews {
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestionTitle.text = NSLocalizedString(@"Translate this sentence:", nil);
  
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  _txtAnswerPlaceholder.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtAnswerPlaceholder.placeholder = NSLocalizedString(@"Your answer...", nil);
  
  _imgAnswerFieldBg.image = [[UIImage imageNamed:@"img-popup-bg.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                             resizingMode:UIImageResizingModeStretch];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _lblQuestionTitle.frame;
    frame.origin.y -= 10;
    _lblQuestionTitle.frame = frame;
    
    frame = _btnQuestionAudio.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 15 : 20;
    _btnQuestionAudio.frame = frame;
    
    frame = _lblQuestion.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 15 : 20;
    _lblQuestion.frame = frame;
    
    frame = _vAnswerField.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 20 : 30;
    _vAnswerField.frame = frame;
    
    frame = _vAnswerTokens.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 25 : 30;
    frame.size.height -= 55;
    _vAnswerTokens.frame = frame;
  }
}

@end
