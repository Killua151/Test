//
//  MMBaseHomeViewController.m
//  memo
//
//  Created by Ethan Nguyen on 10/31/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMBaseAuthenticationViewController.h"
#import "MMSkillsListViewController.h"
#import "MMCoursesListViewController.h"
#import "MUser.h"

@interface MMBaseAuthenticationViewController ()

@end

@implementation MMBaseAuthenticationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  // Implement in child class
}

- (BOOL)validateFields {
  // Implement in child class
  return YES;
}

- (void)loginWithFacebook {
  [Utils logAnalyticsForButton:@"Login Facebook"];
  
  [Utils logInFacebookFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    ShowAlertWithError(error);
    
    ShowHudForCurrentView();
    
    [[MMServerHelper sharedHelper]
     logInWithFacebookId:userData[kParamFbId]
     facebookName:userData[kParamFbName]
     accessToken:userData[kParamFbAccessToken]
     completion:^(NSDictionary *userData, NSError *error) {
       [self handleLoginResponseWithUserData:userData orError:error];
     }];
  }];
}

- (void)loginWithGoogle {
  [Utils logAnalyticsForButton:@"Login Google+"];
  
  ShowHudForCurrentView();
  
  [Utils logInGoogleFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    if (error != nil)
      HideHudForCurrentView();
    
    ShowAlertWithError(error);
    
    [[MMServerHelper sharedHelper]
     logInWithGmail:userData[kParamGmail]
     accessToken:userData[kParamGAccessToken]
     completion:^(NSDictionary *userData, NSError *error) {
       [self handleLoginResponseWithUserData:userData orError:error];
     }];
  }];
}

- (void)handleLoginResponseWithUserData:(NSDictionary *)userData orError:(NSError *)error {
  HideHudForCurrentView();
  ShowAlertWithError(error);
  
  if ([MUser currentUser].current_course_id == nil ||
      [[MUser currentUser].current_course_id isEqualToString:@"null"]) {
    if (_coursesListVC == nil) {
      _coursesListVC = [MMCoursesListViewController new];
      _coursesListVC.delegate = self;
    }
    
    [self.navigationController pushViewController:_coursesListVC animated:YES];
    [_coursesListVC reloadContents];
  } else
    [self transitToViewController:[MMSkillsListViewController navigationController]];
}

#pragma mark - MMCoursesListDelegate delegate
- (void)coursesListDidGoBack {
  [MUser logOutCurrentUser];
}

@end
