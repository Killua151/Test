//
//  FTSpeakQuestionContentView.m
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSpeakQuestionContentView.h"
#import "MSpeakQuestion.h"

@interface FTSpeakQuestionContentView ()

- (void)animateHideTooltips;

@end

@implementation FTSpeakQuestionContentView

- (void)setupViews {
  MSpeakQuestion *questionData = (MSpeakQuestion *)self.questionData;
  
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestionTitle.text = NSLocalizedString(@"Speak this sentence:", nil);
  
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblQuestion.text = questionData.question;
  [Utils adjustLabelToFitHeight:_lblQuestion constrainsToHeight:_btnQuestionAudio.frame.size.height];
  
  CGPoint center = _lblQuestion.center;
  center.y = _btnQuestionAudio.center.y - 3;
  _lblQuestion.center = center;
  
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
  [_btnSkipSpeakQuestion setTitle:NSLocalizedString(@"I can’t use microphone right now", nil) forState:UIControlStateNormal];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _lblQuestionTitle.frame;
    frame.origin.y -= 10;
    _lblQuestionTitle.frame = frame;
    
    frame = _btnQuestionAudio.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 20 : 20;
    _btnQuestionAudio.frame = frame;
    
    frame = _lblQuestion.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 20 : 20;
    _lblQuestion.frame = frame;
    
    frame = _btnTooltips.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 15 : 20;
    _btnTooltips.frame = frame;
    
    frame = _btnRecord.frame;
    frame.size = CGSizeMake(130, 130);
    frame.origin.y -= DeviceSystemIsOS7() ? 15 : 20;
    frame.origin.x += 15;
    _btnRecord.frame = frame;
    
    frame = _btnSkipSpeakQuestion.frame;
    frame.origin.y -= DeviceSystemIsOS7() ? 0 : 10;
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
  DLog(@"invoke");
}

#pragma mark - Private methods
- (void)animateHideTooltips {
  [UIView 
   animateWithDuration:kDefaultAnimationDuration
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
