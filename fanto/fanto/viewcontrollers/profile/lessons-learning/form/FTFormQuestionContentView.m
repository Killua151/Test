//
//  FTFormQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTFormQuestionContentView.h"
#import "FTFormAnswerTokenButton.h"

@interface FTFormQuestionContentView () {
  NSArray *_answerTokensData;
  NSMutableArray *_btnAnswerTokens;
}

- (void)setupTokenButtons;

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
  
  _answerTokensData = [@"Những nước khác nhau thì có nền văn hóa khác nhau" componentsSeparatedByString:@" "];
  _btnAnswerTokens = [NSMutableArray new];
  [self setupTokenButtons];
}

#pragma mark - FTQuestionContentDelegate methods
- (void)formTokenButtonDidSelect:(FTFormAnswerTokenButton *)button {
  DLog(@"%@", button);
}

#pragma mark - Private methods
- (void)setupTokenButtons {
  for (UIView *subview in _vAnswerTokens.subviews)
    [subview removeFromSuperview];
  
  [_btnAnswerTokens removeAllObjects];
  
  CGPoint origin = CGPointMake(3, 3);
  CGFloat buttonsGap = 10;
  
  __block CGFloat currentOffsetX = 0;
  __block CGFloat currentOffsetY = 0;
  __block CGRect frame = CGRectZero;
  
  [_answerTokensData enumerateObjectsUsingBlock:^(NSString *token, NSUInteger index, BOOL *stop) {
    FTFormAnswerTokenButton *button = [[FTFormAnswerTokenButton alloc] initWithToken:token atIndex:index];
    button.delegate = self;
    
    frame = button.frame;
    
    if (origin.x + currentOffsetX + frame.size.width > _vAnswerTokens.frame.size.width) {
      currentOffsetX = 0;
      currentOffsetY += (frame.size.height + buttonsGap);
    }
    
    frame.origin.x = origin.x + currentOffsetX;
    frame.origin.y = origin.y + currentOffsetY;
    button.frame = frame;
    
    currentOffsetX += (frame.size.width + buttonsGap);
    
    [_btnAnswerTokens addObject:button];
    [_vAnswerTokens addSubview:button];
  }];
}

@end
