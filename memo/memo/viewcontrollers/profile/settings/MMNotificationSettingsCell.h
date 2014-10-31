//
//  MMNotificationSettingsCell.h
//  memo
//
//  Created by Ethan Nguyen on 10/31/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMNotificationSettingsCell : BaseTableViewCell {
  IBOutlet UILabel *_lblTitle;
  IBOutlet UIButton *_btnPushNotification;
  IBOutlet UIButton *_btnEmailNotification;
}

- (IBAction)btnPushNotifcationPressed:(UIButton *)sender;
- (IBAction)btnEmailNotificationPressed:(UIButton *)sender;

@end
