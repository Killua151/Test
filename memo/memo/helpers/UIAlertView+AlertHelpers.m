//
//  UIAlertView+AlertHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UIAlertView+AlertHelpers.h"

@interface UIAlertViewInstance : UIAlertView <UIAlertViewDelegate>

@property (nonatomic, copy) void(^callbackHandler)(NSInteger buttonIndex);

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
    _callbackHandler(buttonIndex);
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
                      callback:(void (^)(NSInteger))handler {
  return [[self class] showWithTitle:[NSString stringWithFormat:MMLocalizedString(@"Error %d"), [error errorCode]]
                             message:MMLocalizedString([error errorMessage])
                   cancelButtonTitle:cancelButtonTitle
                   otherButtonTitles:otherButtonTitles
                            callback:handler];
}

+ (UIAlertView *)showWithTitle:(NSString *)title andMessage:(NSString *)message {
  return [[self class] showWithTitle:title
                             message:message
                   cancelButtonTitle:nil
                   otherButtonTitles:nil
                            callback:NULL];
}

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherButtonTitles
                      callback:(void (^)(NSInteger))handler {
  UIAlertViewInstance *alertViewInstance = [UIAlertViewInstance sharedInstance];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:alertViewInstance
                                            cancelButtonTitle:cancelButtonTitle
                                            otherButtonTitles:nil];
  
  for (NSString *otherButtonTitle in otherButtonTitles)
    [alertView addButtonWithTitle:otherButtonTitle];
  
  alertViewInstance.callbackHandler = handler;
  [alertView show];
  
  return alertView;
}

@end
