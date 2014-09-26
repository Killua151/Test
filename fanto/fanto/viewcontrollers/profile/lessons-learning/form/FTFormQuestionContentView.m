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
}

@end
