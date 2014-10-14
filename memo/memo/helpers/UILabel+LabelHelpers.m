//
//  UILabel+LabelHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UILabel+LabelHelpers.h"

@implementation UILabel (LabelHelpers)

- (void)adjustToFitHeight {
  [self adjustToFitHeightAndRelatedTo:nil withDistance:0];
}

- (void)adjustToFitHeightAndConstrainsToHeight:(CGFloat)maxHeight {
  [self adjustToFitHeightAndRelatedTo:nil withDistance:0];
  
  CGRect frame = self.frame;
  frame.size.height = MIN(frame.size.height, maxHeight);
  self.frame = frame;
}

- (void)adjustToFitHeightAndRelatedTo:(UILabel *)otherLabel withDistance:(CGFloat)distance {
  CGSize sizeThatFits = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
  CGRect frame = self.frame;
  
  if (otherLabel != nil)
    frame.origin.y = otherLabel.frame.origin.y + otherLabel.frame.size.height + distance;
  
  frame.size.height = sizeThatFits.height;
  self.frame = frame;
}

- (void)adjustToFitHeightAndConstrainsToHeight:(CGFloat)maxHeight
                                     relatedTo:(UILabel *)otherLabel
                                  withDistance:(CGFloat)distance {
  CGSize sizeThatFits = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
  CGRect frame = self.frame;
  
  if (otherLabel != nil)
    frame.origin.y = otherLabel.frame.origin.y + otherLabel.frame.size.height + distance;
  
  frame.size.height = MIN(sizeThatFits.height, maxHeight);
  self.frame = frame;
}

- (void)applyAttributedText:(NSString *)fullText onString:(NSString *)styledString withAttributes:(NSDictionary *)attributes {
  NSRange styledRange = [fullText rangeOfString:styledString];
  
  if (styledRange.location == NSNotFound) {
    self.text = fullText;
    return;
  }
  
  [self applyAttributedText:fullText inRange:styledRange withAttributes:attributes];
}

- (void)applyAttributedText:(NSString *)fullText inRange:(NSRange)styledRange withAttributes:(NSDictionary *)attributes {
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText];
  [attributedText addAttributes:attributes range:styledRange];
  self.attributedText = attributedText;
}

@end
