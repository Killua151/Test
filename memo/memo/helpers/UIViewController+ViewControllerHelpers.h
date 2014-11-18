//
//  UIViewController+ViewControllerHelpers.h
//  memo
//
//  Created by Ethan Nguyen on 11/18/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewControllerHelpers)

+ (UIViewController *)currentActiveViewController;
- (UIViewController *)topMostViewController;

@end
