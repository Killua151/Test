//
//  FTSettingsViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSettingsViewController.h"
#import "FTSettingsHeaderView.h"

@interface FTSettingsViewController () {
  NSArray *_sectionsData;
  UIView *_currentFirstResponder;
}

- (void)dismiss;
- (void)submitUsernameChange;
- (void)submitPasswordChange;
- (void)submitEmailChange;

@end

@implementation FTSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:@"Cài đặt" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"Đóng" color:[UIColor blackColor] target:self action:@selector(dismiss) distance:-10];
  
  _sectionsData = @[@"Thông tin của bạn", @"Kết nối", @"Thông báo"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [_sectionsData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)
    return 4;
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    switch (indexPath.row) {
      case 0:
        return _celAvatar;
        
      case 1:
        return _celUsername;
        
      case 2:
        return _celPassword;
        
      case 3:
        return _celEmail;
        
      default:
        break;
    }
  }
  
  return nil;
}

#pragma mark - UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  FTSettingsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:
                                NSStringFromClass([FTSettingsHeaderView class])];
  
  if (view == nil)
    view = [FTSettingsHeaderView new];
  
  [view updateViewWithData:_sectionsData[section]];
  
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    switch (indexPath.row) {
      case 0:
        return _celAvatar.frame.size.height;
        
      case 1:
        return _celUsername.frame.size.height;
        
      case 2:
        return _celPassword.frame.size.height;
        
      case 3:
        return _celEmail.frame.size.height;
        
      default:
        break;
    }
  }
  
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return [FTSettingsHeaderView heightToFithWithData:_sectionsData[section]];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  _currentFirstResponder = textField;
  
  if (textField == _txtUsername || textField == _txtPassword || textField == _txtEmail)
    [self animateSlideViewUp:YES withDistance:50];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [_currentFirstResponder resignFirstResponder];
  [self animateSlideViewUp:NO withDistance:0];
  
  if (textField == _txtUsername)
    [self submitUsernameChange];
  else if (textField == _txtPassword)
    [self submitPasswordChange];
  else if (textField == _txtEmail)
    [self submitEmailChange];
  
  return YES;
}

#pragma mark - Private methods
- (void)dismiss {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)submitUsernameChange {
}

- (void)submitPasswordChange {
}

- (void)submitEmailChange {
}

@end
