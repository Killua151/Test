//
//  FTSettingsViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSettingsViewController.h"
#import "MMSettingsHeaderView.h"
#import "MMHomeViewController.h"
#import "MMAppDelegate.h"
#import "MUser.h"

#define kTextFieldTypes           @[kParamUsername, kParamPassword, kParamEmail]
#define kSwitchFrame              CGRectMake(254, 9, 51, 31)

@interface MMSettingsViewController () {
  NSArray *_sectionsData;
  UIView *_currentFirstResponder;
  BOOL _textFieldsShouldEndEditting;
  BOOL _textFieldDidChanged;
  NSMutableDictionary *_userInfo;
}

- (void)setupViews;
- (void)submitChanges;
- (void)confirmTextField:(UITextField *)textField withType:(NSString *)type;
- (void)switchDidChanged:(BOOL)isOn atIndex:(NSInteger)index;
- (void)linkFacebook;
- (void)unlinkFacebook;
- (void)linkGoogle;
- (void)unlinkGoogle;

@end

@implementation MMSettingsViewController

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
  
  _userInfo = [NSMutableDictionary new];
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  _txtEmail.text = [NSString normalizedString:_userData.email];
  _txtUsername.text = [NSString normalizedString:_userData.username];
  _txtPassword.text = @"";

  [_swtFacebook setOn:(_userData.fb_Id != nil && _userData.fb_Id.length > 0) animated:YES shouldCallback:NO];
  [_swtGooglePlus setOn:(_userData.gmail != nil && _userData.gmail.length > 0) animated:YES shouldCallback:NO];
}

- (IBAction)btnSendFeedbackPressed:(UIButton *)sender {
  NSString *toEmail = @"support@memo.edu.vn";
  NSString *subject = @"Memo feedback";
  NSString *messageBody = @"Hi!";
  
  MFMailComposeViewController *controller = [MFMailComposeViewController new];
  controller.mailComposeDelegate = self;
  [controller setToRecipients:@[toEmail]];
  [controller setSubject:subject];
  [controller setMessageBody:messageBody isHTML:NO];
  
  if (controller != nil)
    [self.navigationController presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)btnLogoutPressed:(UIButton *)sender {
  [MUser logOutCurrentUser];
  
  UINavigationController *homeNavigation = [MMHomeViewController navigationController];
  homeNavigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  
  [self presentViewController:homeNavigation animated:YES completion:^{
    MMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
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
  
  MMSettingsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:
                                NSStringFromClass([MMSettingsHeaderView class])];
  
  if (view == nil)
    view = [MMSettingsHeaderView new];
  
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
  
  return [MMSettingsHeaderView heightToFithWithData:_sectionsData[section]];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if (textField == _txtUsername || textField == _txtPassword || textField == _txtEmail) {
    _textFieldDidChanged = NO;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  _textFieldDidChanged = YES;
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
  
  NSString *textFieldType = kTextFieldTypes[alertView.tag-1];
  
  if (alertView.tag >= 1 && alertView.tag <= [kTextFieldTypes count]) {
    UITextField *originalTextField = @[_txtUsername, _txtPassword, _txtEmail][alertView.tag-1];
    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    
    BOOL validField = YES;
    
    if ([textFieldType isEqualToString:kParamUsername])
      validField = [Utils validateBlank:originalTextField.text];
    else if ([textFieldType isEqualToString:kParamPassword])
      validField = [Utils validateBlank:originalTextField.text] && originalTextField.text.length >= 8;
    else if ([textFieldType isEqualToString:kParamEmail])
      validField = [Utils validateEmail:originalTextField.text];
    
    if ([originalTextField.text isEqualToString:alertTextField.text] && validField) {
      _userInfo[textFieldType] = originalTextField.text;
      [self submitChanges];
      return;
    }
    
    [self confirmTextField:originalTextField withType:textFieldType];
  }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
  if (alertView.tag >= 1 && alertView.tag <= [kTextFieldTypes count]) {
    UITextField *alertTextField = [alertView textFieldAtIndex:0];
    [alertTextField becomeFirstResponder];
  }
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  [controller dismissViewControllerAnimated:YES completion:NULL];
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
  
  _swtSoundEffects = [[MMSwitch alloc] initWithFrame:kSwitchFrame];
  _swtListeningLessons = [[MMSwitch alloc] initWithFrame:kSwitchFrame];
  _swtFacebook = [[MMSwitch alloc] initWithFrame:kSwitchFrame];
  _swtGooglePlus = [[MMSwitch alloc] initWithFrame:kSwitchFrame];
  
  __block MMSettingsViewController *selfDelegate = self;
  
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
       MMSwitch *swt = data[@"switch"];
       
       swt.onTintColor = UIColorFromRGB(129, 12, 21);
       swt.didChangeHandler = ^(BOOL isOn) {
         [selfDelegate switchDidChanged:isOn atIndex:index];
       };
       
       [cell.contentView addSubview:swt];
     }];
}

- (void)submitChanges {
  NSString *changeType = [[_userInfo allKeys] firstObject];
  NSString *value = [[_userInfo allValues] firstObject];
  
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [[MMServerHelper sharedHelper] updateProfile:_userInfo completion:^(NSError *error) {
    [Utils hideAllHUDsForView:self.navigationController.view];
    ShowAlertWithError(error);
    
    if ([changeType isEqualToString:kParamUsername])
      _userData.username = value;
    else if ([changeType isEqualToString:kParamEmail])
      _userData.email = value;
  }];
}

- (void)confirmTextField:(UITextField *)textField withType:(NSString *)type {
  [_userInfo removeAllObjects];
  
  if (!_textFieldDidChanged)
    return;
  
  NSString *alertTitle = [NSString stringWithFormat:@"Confirm %@", type];
  NSString *alertMessage = [NSString stringWithFormat:@"Please confirm your %@", type];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(alertTitle, nil)
                                                      message:NSLocalizedString(alertMessage, nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
  
  if ([type isEqualToString:kParamPassword])
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
  else
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  
  alertView.tag = textField.tag+1;
  [alertView show];
}

- (void)switchDidChanged:(BOOL)isOn atIndex:(NSInteger)index {
  switch (index) {
    case 0:
      break;
      
    case 1:
      break;
      
    case 2:
      _swtFacebook.isOn ? [self linkFacebook] : [self unlinkFacebook];
      break;
      
    case 3:
      _swtGooglePlus.isOn ? [self linkGoogle] : [self unlinkGoogle];
      break;
      
    default:
      break;
  }
}

- (void)linkFacebook {
  [_swtFacebook setOn:YES animated:YES shouldCallback:NO];
  
  [Utils logInFacebookFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    ShowAlertWithError(error);
    
    [Utils showHUDForView:self.navigationController.view withText:nil];
    
    [[MMServerHelper sharedHelper]
     linkFacebookWithFacebookId:userData[kParamFbId]
     accessToken:userData[kParamFbAccessToken]
     completion:^(NSError *error) {
       [Utils hideAllHUDsForView:self.navigationController.view];
       
       if (error != nil)
         [_swtFacebook setOn:NO animated:YES shouldCallback:NO];
       else
         _userData.fb_Id = userData[kParamFbId];
       
       ShowAlertWithError(error);
     }];
  }];
}

- (void)unlinkFacebook {
  [_swtFacebook setOn:NO animated:YES shouldCallback:NO];
  
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [[MMServerHelper sharedHelper] unlinkFacebook:^(NSError *error) {
    [Utils hideAllHUDsForView:self.navigationController.view];
    
    if (error != nil)
      [_swtFacebook setOn:YES animated:YES shouldCallback:NO];
    else
      _userData.gmail = @"";
    
    ShowAlertWithError(error);
  }];
}

- (void)linkGoogle {
  [_swtGooglePlus setOn:YES animated:YES shouldCallback:NO];
  
  [Utils logInGoogleFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    ShowAlertWithError(error);
    
    [Utils showHUDForView:self.navigationController.view withText:nil];
    
    [[MMServerHelper sharedHelper]
     linkGoogleWithGmail:userData[kParamGmail]
     accessToken:userData[kParamGAccessToken]
     completion:^(NSError *error) {
       [Utils hideAllHUDsForView:self.navigationController.view];
       
       if (error != nil)
         [_swtGooglePlus setOn:NO animated:YES shouldCallback:NO];
       else
         _userData.gmail = userData[kParamGmail];
       
       ShowAlertWithError(error);
     }];
  }];
}

- (void)unlinkGoogle {
  [_swtGooglePlus setOn:NO animated:YES shouldCallback:NO];
  
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [[MMServerHelper sharedHelper] unlinkGoogle:^(NSError *error) {
    [Utils hideAllHUDsForView:self.navigationController.view];
    
    if (error != nil)
      [_swtGooglePlus setOn:YES animated:YES shouldCallback:NO];
    else
      _userData.gmail = @"";
    
    ShowAlertWithError(error);
  }];
}

@end
