//
//  UIAlertView+AlertHelpers.h
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (AlertHelpers)

+ (UIAlertView *)showWithError:(NSError *)error;
+ (UIAlertView *)showWithError:(NSError *)error delegate:(id)delegate;
+ (UIAlertView *)showWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (UIAlertView *)showWithTitle:(NSString *)title andMessage:(NSString *)message delegate:(id)delegate;

@end
