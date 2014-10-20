//
//  UILabel+LabelHelpers.h
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHelpers)

- (void)adjustToFitHeight;
- (void)adjustToFitHeightAndConstrainsToHeight:(CGFloat)maxHeight;
- (void)adjustToFitHeightAndRelatedTo:(UILabel *)otherLabel withDistance:(CGFloat)distance;
- (void)adjustToFitHeightAndConstrainsToHeight:(CGFloat)maxHeight
                                     relatedTo:(UILabel *)otherLabel
                                  withDistance:(CGFloat)distance;

- (void)applyAttributedText:(NSString *)fullText onString:(NSString *)styledString withAttributes:(NSDictionary *)attributes;
- (void)applyAttributedText:(NSString *)fullText inRange:(NSRange)styledRange withAttributes:(NSDictionary *)attributes;
- (CGRect)boundingRectForCharacterRange:(NSRange)range;
- (CGRect)rectForLetterAtIndex:(NSUInteger)index;

@end

@interface TTTAttributedLabel (LabelHelpers)

- (void)applyWordDefinitions:(NSArray *)words withSpecialWords:(NSArray *)specialWords;

@end