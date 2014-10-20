//
//  FTAllowsTouchButtonView.m
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMAllowsTouchUnderneathView.h"

@interface MMAllowsTouchUnderneathView ()

- (UIView *)recursivelyFindTouchAllowedUnderneathViewInView:(UIView *)siblingView atPoint:(CGPoint)touchPoint;

@end

@implementation MMAllowsTouchUnderneathView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  if (!_touchUnderneathEnabled)
    return [super hitTest:point withEvent:event];
  
  if (self.hidden || !self.userInteractionEnabled)
    return nil;
  
  if (self.superview == nil)
    return self;
  
  NSInteger selfIndex = [self.superview.subviews indexOfObject:self];
  
  if (selfIndex == NSNotFound)
    return self;
  
  // Enumerate from the first deeper sibling view
  for (NSInteger index = selfIndex-1; index >= 0; index--) {
    UIView *siblingView = self.superview.subviews[index];
    
    UIView *foundButton = [self
                           recursivelyFindTouchAllowedUnderneathViewInView:siblingView
                           atPoint:[self convertPoint:point toView:self.superview]];
    
    if (foundButton != nil)
      return foundButton;
  }
  
  return self;
}

#pragma mark - Private methods
- (UIView *)recursivelyFindTouchAllowedUnderneathViewInView:(UIView *)siblingView atPoint:(CGPoint)touchPoint {
  CGPoint convertedPoint = [siblingView.superview convertPoint:touchPoint toView:siblingView];
  
  for (UIView *subview in [siblingView.subviews reverseObjectEnumerator]) {
    if (![subview isKindOfClass:[UIView class]] || !subview.userInteractionEnabled || subview.hidden)
      continue;
    
    if (([subview isMemberOfClass:[UIButton class]] ||
         [subview isMemberOfClass:[UITextView class]] ||
         [subview isMemberOfClass:[UITextField class]]) &&
        subview.tag == kTagTouchAllowedUnderneathView) {
      if (CGRectContainsPoint(subview.frame, convertedPoint))
        return subview;
    } else {
      UIView *foundView = [self recursivelyFindTouchAllowedUnderneathViewInView:subview atPoint:convertedPoint];
      
      if (foundView != nil)
        return foundView;
    }
  }
  
  return nil;
}

@end
