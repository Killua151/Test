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

@end

@implementation MMNotificationSettingsCell

- (id)init {
  if (self = [super init]) {
    _lblTitle.font = [UIFont fontWithName:@"ClearSans" size:14];
  }
  
  return self;
}

- (void)updateCellWithData:(MSettings *)data {
  _lblTitle.text = data.notification_title;
  _btnPushNotification.selected = data.push_notification_enabled;
  _btnEmailNotification.selected = data.email_notification_enabled;
}

- (IBAction)btnPushNotifcationPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
  _settingsData.push_notification_enabled = sender.selected;
}

- (IBAction)btnEmailNotificationPressed:(UIButton *)sender {
  sender.selected = !sender.selected;
  _settingsData.email_notification_enabled = sender.selected;
}

@end
