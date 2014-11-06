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

+ (UIAlertView *)showWithError:(NSError *)error
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                      callback:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))handler;

+ (UIAlertView *)showWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                      callback:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))handler;

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                      callback:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))handler;

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                         style:(UIAlertViewStyle)alertStyle
                      callback:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))handler;

@end
