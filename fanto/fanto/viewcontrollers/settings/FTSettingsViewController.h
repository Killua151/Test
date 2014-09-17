//
//  FTSettingsViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTSettingsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
  IBOutlet UITableView *_tblSettings;
  IBOutlet UITableViewCell *_celAvatar;
  IBOutlet UITableViewCell *_celUsername;
  IBOutlet UITextField *_txtUsername;
  IBOutlet UITableViewCell *_celPassword;
  IBOutlet UITextField *_txtPassword;
  IBOutlet UITableViewCell *_celEmail;
  IBOutlet UITextField *_txtEmail;
  IBOutlet UITableViewCell *_celFeedbackLogOut;
  IBOutlet UITableViewCell *_celSoundEffects;
  IBOutlet UISwitch *_swtSoundEffects;
  IBOutlet UITableViewCell *_celListeningLessons;
  IBOutlet UISwitch *_swtListeningLessons;
}

- (IBAction)btnSendFeedbackPressed:(UIButton *)sender;
- (IBAction)btnLogoutPressed:(UIButton *)sender;
- (IBAction)swtSoundEffectsChanged:(UISwitch *)sender;
- (IBAction)swtListeningLessonsChanged:(UISwitch *)sender;

@end
