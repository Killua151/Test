//
//  FTAllowsTouchOutsideView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/23/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTAllowsTouchOutsideView.h"

@implementation FTAllowsTouchOutsideView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
      CGPoint subPoint = [subview convertPoint:point fromView:self];
      UIView *result = [subview hitTest:subPoint withEvent:event];
      
      if (result != nil)
        return result;
    }
  }
  
  return nil;
}

@end
