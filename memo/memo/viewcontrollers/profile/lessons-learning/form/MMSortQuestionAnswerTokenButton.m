//
//  FTFormAnswerTokenButton.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSortQuestionAnswerTokenButton.h"

@interface MMSortQuestionAnswerTokenButton () {
  NSInteger _index;
}

- (void)setupViews;

@end

@implementation MMSortQuestionAnswerTokenButton

- (id)initWithToken:(NSString *)token atIndex:(NSInteger)index {
  if (self = [super init]) {
    LoadXibWithSameClass();
    
    _token = token;
    _index = index;
    [self setupViews];
  }
  
  return self;
}

- (IBAction)btnTokenPressed:(UIButton *)sender {
  if ([_delegate respondsToSelector:@selector(formTokenButtonDidSelect:)])
    [_delegate formTokenButtonDidSelect:self];
}

#pragma mark - Private methods
- (void)setupViews {
  _btnToken.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnToken setTitle:_token forState:UIControlStateNormal];
  CGSize sizeThatFits = [_btnToken sizeThatFits:CGSizeMake(MAXFLOAT, _btnToken.frame.size.height)];
  
  CGRect frame = self.frame;
  frame.size.width = sizeThatFits.width + 6;
  self.frame = frame;
  
  _imgBg.image = [_imgBg.image resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 4, 3)
                                              resizingMode:UIImageResizingModeStretch];
}

@end
