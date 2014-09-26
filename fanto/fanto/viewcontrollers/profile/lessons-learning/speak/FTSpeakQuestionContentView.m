//
//  FTSpeakQuestionContentView.m
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSpeakQuestionContentView.h"

@interface FTSpeakQuestionContentView ()

- (void)animateHideTooltips;

@end

@implementation FTSpeakQuestionContentView

- (void)setupViews {
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  NSString *styledString = NSLocalizedString(@"Tap", nil);
  NSString *tooltipsMessage = [NSString stringWithFormat:NSLocalizedString(@"%@ to start recording", nil), styledString];
  _btnTooltips.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [Utils applyAttributedTextForLabel:_btnTooltips.titleLabel
                            withText:tooltipsMessage
                            onString:styledString
                      withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17]}];
  
  _btnSkipSpeakQuestion.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSkipSpeakQuestion.layer.cornerRadius = 4;
  _btnSkipSpeakQuestion.layer.borderColor = [UIColorFromRGB(179, 179, 179) CGColor];
  _btnSkipSpeakQuestion.layer.borderWidth = 2;
  [_btnSkipSpeakQuestion setTitle:NSLocalizedString(@"I can’t use microphone right now", nil)
                         forState:UIControlStateNormal];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _lblQuestionTitle.frame;
    frame.origin.y -= 10;
    _lblQuestionTitle.frame = frame;
    
    frame = _btnQuestionAudio.frame;
    frame.origin.y -= 15;
    _btnQuestionAudio.frame = frame;
    
    frame = _lblQuestion.frame;
    frame.origin.y -= 15;
    _lblQuestion.frame = frame;
    
    frame = _btnTooltips.frame;
    frame.origin.y -= 15;
    _btnTooltips.frame = frame;
    
    frame = _btnRecord.frame;
    frame.size = CGSizeMake(130, 130);
    frame.origin.y -= 15;
    frame.origin.x += 15;
    _btnRecord.frame = frame;
    
    frame = _btnSkipSpeakQuestion.frame;
    frame.origin.y -= 55;
    _btnSkipSpeakQuestion.frame = frame;
  }
}

- (IBAction)btnTooltipsPressed:(UIButton *)sender {
  [self animateHideTooltips];
}

- (IBAction)btnRecordTouchedDown:(UIButton *)sender {
  if (!_btnTooltips.hidden)
    [self animateHideTooltips];
}

- (IBAction)btnRecordPressed:(UIButton *)sender {
}

- (IBAction)btnSkipSpeakQuestionPressed:(UIButton *)sender {
}

#pragma mark - Private methods
- (void)animateHideTooltips {
  [UIView 
   animateWithDuration:0.5
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut 
   animations:^{
     _btnTooltips.alpha = 0;
   }
   completion:^(BOOL finished) {
     _btnTooltips.hidden = YES;
   }];
}

@end
