//
//  FTSettingsViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSettingsViewController.h"
#import "FTSettingsHeaderView.h"
#import "FTHomeViewController.h"
#import "FTAppDelegate.h"
#import "MUser.h"

#define kTextFieldTypes           @[@"username", @"password", @"email"]
#define kSwitchFrame              CGRectMake(254, 9, 51, 31)

@interface FTSettingsViewController () {
  NSArray *_sectionsData;
  UIView *_currentFirstResponder;
  BOOL _textFieldsShouldEndEditting;
}

- (void)setupViews;
- (void)submitChanges;
- (void)confirmTextField:(UITextField *)textField withType:(NSString *)type;
- (void)switchDidChanged:(BOOL)isOn atIndex:(NSInteger)index;

@end

@implementation FTSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:NSLocalizedString(@"Settings", nil) color:[UIColor blackColor]];
  
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Close", nil)
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(goBack)
                        distance:-8];
  
  _sectionsData = @[NSLocalizedString(@"Your infomation", nil),
                    [NSNull null],
                    [NSNull null],
                    NSLocalizedString(@"Connections", nil),
                    NSLocalizedString(@"Notifications", nil)];
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  MUser *currentUser = [MUser currentUser];
  
  _txtEmail.text = [Utils normalizeString:currentUser.email];
  _txtUsername.text = [Utils normalizeString:currentUser.username];
  _txtPassword.text = @"";
}

- (IBAction)btnSendFeedbackPressed:(UIButton *)sender {
}

- (IBAction)btnLogoutPressed:(UIButton *)sender {
  [MUser logOutCurrentUser];
  
  UINavigationController *homeNavigation = [FTHomeViewController navigationController];
  homeNavigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  
  [self.navigationController presentViewController:homeNavigation animated:YES completion:^{
    FTAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = homeNavigation;
  }];
}

- (IBAction)btnNotificationModesPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [_sectionsData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)
    return 4;
  
  if (section == 1)
    return 1;
  
  if (section == 2 || section == 3)
    return 2;
  
  if (section == 4)
    return 3;
  
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
  
  if (indexPath.section == 1)
    return _celFeedbackLogOut;
  
  if (indexPath.section == 2) {
    if (indexPath.row == 0)
      return _celSoundEffects;
    
    return _celListeningLessons;
  }
  
  if (indexPath.section == 3) {
    if (indexPath.row == 0)
      return _celFacebook;
    
    return _celGooglePlus;
  }
  
  if (indexPath.section == 4) {
    if (indexPath.row == 0)
      return _celPracticeReminder;
    
    if (indexPath.row == 1)
      return _celFriendAdded;
    
    return _celFriendPassed;
  }
  
  return nil;
}

#pragma mark - UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if ([_sectionsData[section] isKindOfClass:[NSNull class]])
    return nil;
  
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
  
  if (indexPath.section == 1)
    return _celFeedbackLogOut.frame.size.height;
  
  if (indexPath.section == 2) {
    if (indexPath.row == 0)
      return _celSoundEffects.frame.size.height;
    
    return _celListeningLessons.frame.size.height;
  }
  
  if (indexPath.section == 3) {
    if (indexPath.row == 0)
      return _celFacebook.frame.size.height;
    
    return _celGooglePlus.frame.size.height;
  }
  
  if (indexPath.section == 4) {
    if (indexPath.row == 0)
      return _celPracticeReminder.frame.size.height;
    
    if (indexPath.row == 1)
      return _celFriendAdded.frame.size.height;
    
    return _celFriendPassed.frame.size.height;
  }
  
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([_sectionsData[section] isKindOfClass:[NSNull class]])
    return 0;
  
  return [FTSettingsHeaderView heightToFithWithData:_sectionsData[section]];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if (textField == _txtUsername || textField == _txtPassword || textField == _txtEmail) {
    _currentFirstResponder = textField;
    _textFieldsShouldEndEditting = NO;
    [self animateSlideViewUp:YES withDistance:50];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  _textFieldsShouldEndEditting = YES;
  [_currentFirstResponder resignFirstResponder];
  _currentFirstResponder = nil;
  
  [self animateSlideViewUp:NO withDistance:0];
  [self confirmTextField:textField withType:kTextFieldTypes[textField.tag]];
  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  // Prevent user from switching between text fields
  return _textFieldsShouldEndEditting;
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    return;
  
  if (alertView.tag >= 1 && alertView.tag <= [kTextFieldTypes count]) {
    UITextField *originalTextField = @[_txtUsername, _txtPassword, _txtEmail][alertView.tag-1];
    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    
    if ([originalTextField.text isEqualToString:alertTextField.text])
      return;
    
    [self confirmTextField:originalTextField withType:kTextFieldTypes[alertView.tag-1]];
  }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
  if (alertView.tag >= 1 && alertView.tag <= [kTextFieldTypes count]) {
    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    [alertTextField becomeFirstResponder];
  }
}

#pragma mark - Private methods
- (void)setupViews {
  _tblSettings.tableFooterView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(320, 20)}];
  
  NSArray *localizedTitles = @[
                               NSLocalizedString(@"Avatar", nil),
                               NSLocalizedString(@"Username", nil),
                               NSLocalizedString(@"Password", nil),
                               NSLocalizedString(@"Email", nil),
                               NSLocalizedString(@"Sound effects", nil),
                               NSLocalizedString(@"Listening lessons", nil),
                               NSLocalizedString(@"Facebook", nil),
                               NSLocalizedString(@"Google+", nil),
                               NSLocalizedString(@"Practice reminder", nil),
                               NSLocalizedString(@"Someone add as friend", nil),
                               NSLocalizedString(@"Someone passed you", nil)
                               ];
  
  [_lblTitles enumerateObjectsUsingBlock:^(UILabel *titleLabel, NSUInteger index, BOOL *stop) {
    titleLabel.font = [UIFont fontWithName:@"ClearSans" size:14];
    titleLabel.textColor = UIColorFromRGB(102, 102, 102);
    titleLabel.text = localizedTitles[index];
  }];
  
  _btnAvatar.layer.cornerRadius = _btnAvatar.frame.size.width/2;
  
  _txtEmail.font = [UIFont fontWithName:@"ClearSans" size:14];
  _txtPassword.font = [UIFont fontWithName:@"ClearSans" size:14];
  _txtUsername.font = [UIFont fontWithName:@"ClearSans" size:14];
  
  _btnFeedback.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnFeedback.layer.cornerRadius = 4;
  [_btnFeedback setTitle:NSLocalizedString(@"Send feedback", nil) forState:UIControlStateNormal];
  
  _btnLogOut.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogOut.layer.cornerRadius = 4;
  _btnLogOut.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnLogOut.layer.borderWidth = 2;
  [_btnLogOut setTitle:NSLocalizedString(@"Log out", nil) forState:UIControlStateNormal];
  
  _swtSoundEffects = [[KLSwitch alloc] initWithFrame:kSwitchFrame];
  _swtListeningLessons = [[KLSwitch alloc] initWithFrame:kSwitchFrame];
  _swtFacebook = [[KLSwitch alloc] initWithFrame:kSwitchFrame];
  _swtGooglePlus = [[KLSwitch alloc] initWithFrame:kSwitchFrame];
  
  [@[
     @{
       @"cell" : _celSoundEffects,
       @"switch" : _swtSoundEffects,
       },
     @{
       @"cell" : _celListeningLessons,
       @"switch" : _swtListeningLessons,
       },
     @{
       @"cell" : _celFacebook,
       @"switch" : _swtFacebook,
       },
     @{
       @"cell" : _celGooglePlus,
       @"switch" : _swtGooglePlus,
       }
     ] enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger index, BOOL *stop) {
       UITableViewCell *cell = data[@"cell"];
       KLSwitch *swt = data[@"switch"];
       
       swt.onTintColor = UIColorFromRGB(129, 12, 21);
       swt.didChangeHandler = ^(BOOL isOn) {
         [self switchDidChanged:isOn atIndex:index];
       };
       [cell.contentView addSubview:swt];
     }];
}

- (void)submitChanges {
}

- (void)confirmTextField:(UITextField *)textField withType:(NSString *)type {
  NSString *alertTitle = [NSString stringWithFormat:@"Confirm %@", type];
  NSString *alertMessage = [NSString stringWithFormat:@"Please confirm your %@", type];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(alertTitle, nil)
                                                      message:NSLocalizedString(alertMessage, nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
  
  if ([type isEqualToString:@"password"])
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
  else
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  
  alertView.tag = textField.tag+1;
  [alertView show];
}

- (void)switchDidChanged:(BOOL)isOn atIndex:(NSInteger)index {
}

@end
