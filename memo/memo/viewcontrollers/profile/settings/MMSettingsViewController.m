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
#import "MMNotificationSettingsCell.h"
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
- (void)toggleLocalSavedSettings:(NSString *)settingsKey;
- (void)linkFacebook;
- (void)unlinkFacebook;
- (void)linkGoogle;
- (void)unlinkGoogle;

@end

@implementation MMSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:MMLocalizedString(@"Settings") color:[UIColor blackColor]];
  
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  
  [self customBarButtonWithImage:nil
                           title:MMLocalizedString(@"Close")
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(goBack)
                        distance:-8];
  
  _sectionsData = @[
                    MMLocalizedString(@"Your infomation"),
                    [NSNull null],
                    [NSNull null],
                    MMLocalizedString(@"Connections"),
                    MMLocalizedString(@"Notifications")
                    ];
  
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

  BOOL soundEffectsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSoundEffectsEnabled];
  [_swtSoundEffects setOn:soundEffectsEnabled animated:YES shouldCallback:NO];
  
  BOOL speakEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSpeakEnabled];
  [_swtSpeakingLessons setOn:speakEnabled animated:YES shouldCallback:NO];
  
  [_swtFacebook setOn:(_userData.fb_Id != nil && _userData.fb_Id.length > 0) animated:YES shouldCallback:NO];
  [_swtGooglePlus setOn:(_userData.gmail != nil && _userData.gmail.length > 0) animated:YES shouldCallback:NO];
  
  [_tblSettings reloadData];
}

- (IBAction)btnSendFeedbackPressed:(UIButton *)sender {
  NSString *toEmail = kValueSupportEmail;
  NSString *subject = MMLocalizedString(@"Memo app feedback");
  NSString *messageBody = MMLocalizedString(@"Hi Memo team!");
  
  MFMailComposeViewController *controller = [MFMailComposeViewController new];
  controller.mailComposeDelegate = self;
  [controller setToRecipients:@[toEmail]];
  [controller setSubject:subject];
  [controller setMessageBody:messageBody isHTML:NO];
  
  if (controller != nil)
    [self.navigationController presentViewController:controller animated:YES completion:NULL];
}

- (IBAction)btnLogoutPressed:(UIButton *)sender {
  ShowHudForCurrentView();

  [[MMServerHelper sharedHelper] logout:^(NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    [MUser logOutCurrentUser];
    [self transitToViewController:[MMHomeViewController navigationController]];
  }];
}

- (IBAction)btnNotificationModesPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  BOOL noNotificationSettings = [[MUser currentUser].settings count] == 0;
  return [_sectionsData count] - noNotificationSettings;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)
    return 4;
  
  if (section == 1)
    return 1;
  
  if (section == 2 || section == 3)
    return 2;
  
  if (section == 4)
    return [[MUser currentUser].settings count];
  
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
    MMNotificationSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        NSStringFromClass([MMNotificationSettingsCell class])];
    
    if (cell == nil)
      cell = [MMNotificationSettingsCell new];
    
    [cell updateCellWithData:[MUser currentUser].settings[indexPath.row]];
    return cell;
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
  
  if (indexPath.section == 4)
    return [MMNotificationSettingsCell heightToFitWithData:[MUser currentUser].settings[indexPath.row]];
  
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([_sectionsData[section] isKindOfClass:[NSNull class]])
    return 0;
  
  return [MMSettingsHeaderView heightToFithWithData:_sectionsData[section]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [Utils logAnalyticsForScrollingOnScreen:self withScrollView:scrollView];
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
      validField = [originalTextField.text validateBlank];
    else if ([textFieldType isEqualToString:kParamPassword])
      validField = [originalTextField.text validateBlank] && originalTextField.text.length >= 8;
    else if ([textFieldType isEqualToString:kParamEmail])
      validField = [originalTextField.text validateEmail];
    
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
                               MMLocalizedString(@"Avatar"),
                               MMLocalizedString(@"Username"),
                               MMLocalizedString(@"Password"),
                               MMLocalizedString(@"Email"),
                               MMLocalizedString(@"Sound effects"),
                               MMLocalizedString(@"Speaking lessons"),
                               MMLocalizedString(@"Facebook"),
                               MMLocalizedString(@"Google+")
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
  [_btnFeedback setTitle:MMLocalizedString(@"Send feedback") forState:UIControlStateNormal];
  
  _btnLogOut.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogOut.layer.cornerRadius = 4;
  _btnLogOut.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnLogOut.layer.borderWidth = 2;
  [_btnLogOut setTitle:MMLocalizedString(@"Log out") forState:UIControlStateNormal];
  
  _swtSoundEffects = [[MMSwitch alloc] initWithFrame:kSwitchFrame];
  _swtSpeakingLessons = [[MMSwitch alloc] initWithFrame:kSwitchFrame];
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
       @"switch" : _swtSpeakingLessons,
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
  
  _lblAppVersion.font = [UIFont fontWithName:@"ClearSans" size:14];
  _lblAppVersion.text = [NSString stringWithFormat:@"v%@", CurrentBuildVersion()];
}

- (void)submitChanges {
  NSString *changeType = [[_userInfo allKeys] firstObject];
  NSString *value = [[_userInfo allValues] firstObject];
  
  ShowHudForCurrentView();
  
  [[MMServerHelper sharedHelper] updateProfile:_userInfo completion:^(NSError *error) {
    HideHudForCurrentView();
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
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:MMLocalizedString(alertTitle)
                                                      message:MMLocalizedString(alertMessage)
                                                     delegate:self
                                            cancelButtonTitle:MMLocalizedString(@"Cancel")
                                            otherButtonTitles:MMLocalizedString(@"OK"), nil];
  
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
      [self toggleLocalSavedSettings:kUserDefSoundEffectsEnabled];
      break;
      
    case 1:
      [self toggleLocalSavedSettings:kUserDefSpeakEnabled];
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

- (void)toggleLocalSavedSettings:(NSString *)settingsKey {
  [Utils logAnalyticsForButton:[NSString stringWithFormat:@"settings toggle %@", settingsKey]];
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ([userDefaults objectForKey:settingsKey] == nil)
    return;
  
  BOOL savedSettings = [userDefaults boolForKey:settingsKey];
  [userDefaults setBool:!savedSettings forKey:settingsKey];
  
  [userDefaults synchronize];
}

- (void)linkFacebook {
  [Utils logAnalyticsForButton:@"settings link Facebook"];
  
  [_swtFacebook setOn:YES animated:YES shouldCallback:NO];
  
  [Utils logInFacebookFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    ShowAlertWithError(error);
    
    ShowHudForCurrentView();
    
    [[MMServerHelper sharedHelper]
     linkFacebookWithFacebookId:userData[kParamFbId]
     accessToken:userData[kParamFbAccessToken]
     completion:^(NSError *error) {
       HideHudForCurrentView();
       
       if (error != nil)
         [_swtFacebook setOn:NO animated:YES shouldCallback:NO];
       else
         _userData.fb_Id = userData[kParamFbId];
       
       ShowAlertWithError(error);
     }];
  }];
}

- (void)unlinkFacebook {
  [Utils logAnalyticsForButton:@"settings unlink Facebook"];
  
  [_swtFacebook setOn:NO animated:YES shouldCallback:NO];
  
  [Utils logOutFacebookWithCompletion:^(NSError *error) {
    ShowAlertWithError(error);
    
    ShowHudForCurrentView();
    
    [[MMServerHelper sharedHelper] unlinkFacebook:^(NSError *error) {
      HideHudForCurrentView();
      
      if (error != nil)
        [_swtFacebook setOn:YES animated:YES shouldCallback:NO];
      else
        _userData.fb_Id = @"";
      
      ShowAlertWithError(error);
    }];
  }];
}

- (void)linkGoogle {
  [Utils logAnalyticsForButton:@"settings link Google+"];
  
  [_swtGooglePlus setOn:YES animated:YES shouldCallback:NO];
  
  [Utils logInGoogleFromView:self.navigationController.view completion:^(NSDictionary *userData, NSError *error) {
    ShowAlertWithError(error);
    
    ShowHudForCurrentView();
    
    [[MMServerHelper sharedHelper]
     linkGoogleWithGmail:userData[kParamGmail]
     accessToken:userData[kParamGAccessToken]
     completion:^(NSError *error) {
       HideHudForCurrentView();
       
       if (error != nil)
         [_swtGooglePlus setOn:NO animated:YES shouldCallback:NO];
       else
         _userData.gmail = userData[kParamGmail];
       
       ShowAlertWithError(error);
     }];
  }];
}

- (void)unlinkGoogle {
  [Utils logAnalyticsForButton:@"settings unlink Google+"];
  
  [_swtGooglePlus setOn:NO animated:YES shouldCallback:NO];
  
  [Utils logOutGoogleWithCompletion:^(NSError *error) {
    ShowAlertWithError(error);
    
    ShowHudForCurrentView();
    
    [[MMServerHelper sharedHelper] unlinkGoogle:^(NSError *error) {
      HideHudForCurrentView();
      
      if (error != nil)
        [_swtGooglePlus setOn:YES animated:YES shouldCallback:NO];
      else
        _userData.gmail = @"";
      
      ShowAlertWithError(error);
    }];
  }];
}

@end
