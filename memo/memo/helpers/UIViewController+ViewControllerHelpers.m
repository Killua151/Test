//
//  UIViewController+ViewControllerHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 11/18/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UIViewController+ViewControllerHelpers.h"

@implementation UIViewController (ViewControllerHelpers)

+ (UIViewController *)currentActiveViewController {
  return [[UIApplication sharedApplication].keyWindow.rootViewController topMostViewController];
}

- (UIViewController *)topMostViewController {
  if (self.presentedViewController == nil)
    return self;
  
  if ([self.presentedViewController isMemberOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
    UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
    return [lastViewController topMostViewController];
  }
  
  UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
  return [presentedViewController topMostViewController];
}

@end
