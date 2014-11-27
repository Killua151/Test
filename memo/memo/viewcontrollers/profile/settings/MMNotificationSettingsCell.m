//
//  MMNotificationSettingsCell.m
//  memo
//
//  Created by Ethan Nguyen on 10/31/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMNotificationSettingsCell.h"
#import "MSettings.h"

@interface MMNotificationSettingsCell () {
  MSettings *_settingsData;
}

- (void)updateNotificationSettingsWithKey:(NSString *)settingsKey forButton:(UIButton *)button;

@end

@implementation MMNotificationSettingsCell

- (id)init {
  if (self = [super init]) {
    _lblTitle.font = [UIFont fontWithName:@"ClearSans" size:14];
  }
  
  return self;
}

- (void)updateCellWithData:(MSettings *)data {
  _settingsData = data;
  
  _lblTitle.text = data.notification_title;
  _btnPushNotification.selected = data.push_notification_enabled;
  _btnEmailNotification.selected = data.email_notification_enabled;
}

- (IBAction)btnPushNotifcationPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
  
  _settingsData.push_notification_enabled = sender.selected;
  
  [self updateNotificationSettingsWithKey:kParamPushNotificationEnabled forButton:sender];
}

- (IBAction)btnEmailNotificationPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
  _settingsData.email_notification_enabled = sender.selected;
  
  [self updateNotificationSettingsWithKey:kParamEmailNotificationEnabled forButton:sender];
}

#pragma mark - Private methods
- (void)updateNotificationSettingsWithKey:(NSString *)settingsKey forButton:(UIButton *)button {
  UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
  [Utils showAntLoadingForView:topWindow];
  
  [[MMServerHelper apiHelper]
   updateNotificationSettings:_settingsData._id
   withKey:settingsKey
   andValue:button.selected
   completion:^(NSError *error) {
     [Utils hideCurrentShowingAntLoading];
     
     if (error != nil) {
       button.selected = !button.selected;
       
       if ([settingsKey isEqualToString:kParamPushNotificationEnabled])
         _settingsData.push_notification_enabled = button.selected;
       else if ([settingsKey isEqualToString:kParamEmailNotificationEnabled])
         _settingsData.email_notification_enabled = button.selected;
     }
     
     ShowAlertWithError(error);
   }];
}

@end
