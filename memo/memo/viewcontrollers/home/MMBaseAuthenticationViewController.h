//
//  MMBaseHomeViewController.h
//  memo
//
//  Created by Ethan Nguyen on 10/31/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "BaseViewController.h"

@class MMCoursesListViewController;

@interface MMBaseAuthenticationViewController : BaseViewController <MMCoursesListDelegate> {
  UIView *_currentFirstResponder;
  MMCoursesListViewController *_coursesListVC;
}

- (void)setupViews;
- (BOOL)validateFields;
- (void)loginWithFacebook;
- (void)loginWithGoogle;
- (void)handleLoginResponseWithUserData:(NSDictionary *)userData orError:(NSError *)error;

@end
