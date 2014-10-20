//
//  UIAlertView+AlertHelpers.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "UIAlertView+AlertHelpers.h"

@implementation UIAlertView (AlertHelpers)

+ (UIAlertView *)showWithError:(NSError *)error {
  return [[self class] showWithTitle:[NSString stringWithFormat:MMLocalizedString(@"Error %d"), [error errorCode]]
                          andMessage:MMLocalizedString([error errorMessage])
                            delegate:nil];
}

+ (UIAlertView *)showWithError:(NSError *)error delegate:(id)delegate {
  return [[self class] showWithTitle:[NSString stringWithFormat:MMLocalizedString(@"Error %d"), [error errorCode]]
                          andMessage:MMLocalizedString([error errorMessage])
                            delegate:delegate];
}

+ (UIAlertView *)showWithTitle:(NSString *)title andMessage:(NSString *)message {
  return [[self class] showWithTitle:title andMessage:message delegate:nil];
}

+ (UIAlertView *)showWithTitle:(NSString *)title andMessage:(NSString *)message delegate:(id)delegate {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:delegate
                                            cancelButtonTitle:MMLocalizedString(@"OK")
                                            otherButtonTitles:nil];
  [alertView show];
  
  return alertView;
}

@end
