//
//  UIAlertView+AlertHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UIAlertView+AlertHelpers.h"

@interface UIAlertViewInstance : UIAlertView <UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, copy) void(^callbackHandler)(UIAlertView *alertView, NSInteger buttonIndex);

+ (instancetype)sharedInstance;

@end

@implementation UIAlertViewInstance

+ (instancetype)sharedInstance {
  static UIAlertViewInstance *_sharedInstance;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [UIAlertViewInstance new];
  });
  
  return _sharedInstance;
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (_callbackHandler != NULL)
    _callbackHandler(_alertView, buttonIndex);
}

@end

@implementation UIAlertView (AlertHelpers)

+ (UIAlertView *)showWithError:(NSError *)error {
  return [[self class] showWithTitle:[NSString stringWithFormat:MMLocalizedString(@"Error %d"), [error errorCode]]
                             message:MMLocalizedString([error errorMessage])
                   cancelButtonTitle:MMLocalizedString(@"OK")
                   otherButtonTitles:nil
                            callback:NULL];
}

+ (UIAlertView *)showWithError:(NSError *)error
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                      callback:(void (^)(UIAlertView *, NSInteger))handler {
  return [[self class] showWithTitle:[NSString stringWithFormat:MMLocalizedString(@"Error %d"), [error errorCode]]
                             message:MMLocalizedString([error errorMessage])
                   cancelButtonTitle:cancelButtonTitle
                   otherButtonTitles:otherButtonTitles
                            callback:handler];
}

+ (UIAlertView *)showWithTitle:(NSString *)title andMessage:(NSString *)message {
  return [[self class] showWithTitle:title
                             message:message
                   cancelButtonTitle:MMLocalizedString(@"OK")
                   otherButtonTitles:nil
                            callback:NULL];
}

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                      callback:(void (^)(UIAlertView *, NSInteger))handler {
  return [[self class] showWithTitle:title
                             message:message
                   cancelButtonTitle:MMLocalizedString(@"OK")
                   otherButtonTitles:nil
                            callback:handler];
}

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                      callback:(void (^)(UIAlertView *, NSInteger))handler {
  return [[self class] showWithTitle:title
                             message:message
                   cancelButtonTitle:cancelButtonTitle
                   otherButtonTitles:otherButtonTitles
                               style:UIAlertViewStyleDefault
                            callback:handler];
}

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                         style:(UIAlertViewStyle)alertStyle
                      callback:(void (^)(UIAlertView *, NSInteger))handler {
  UIAlertViewInstance *alertViewInstance = [UIAlertViewInstance sharedInstance];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:alertViewInstance
                                            cancelButtonTitle:cancelButtonTitle
                                            otherButtonTitles:nil];
  
  alertView.alertViewStyle = alertStyle;
  
  for (NSString *otherButtonTitle in otherButtonTitles)
    [alertView addButtonWithTitle:otherButtonTitle];
  
  alertViewInstance.alertView = alertView;
  alertViewInstance.callbackHandler = handler;
  [alertView show];
  
  return alertView;
}

@end
