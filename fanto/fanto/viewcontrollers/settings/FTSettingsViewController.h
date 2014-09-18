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
  IBOutlet UITableViewCell *_celListensingLessons;
  IBOutlet UISwitch *_swtListeningLessons;
  IBOutlet UITableViewCell *_celFacebook;
  IBOutlet UISwitch *_swtFacebook;
  IBOutlet UITableViewCell *_celGooglePlus;
  IBOutlet UISwitch *_swtGooglePlus;
  IBOutlet UITableViewCell *_celPracticeReminder;
  IBOutlet UIButton *_btnPracticeReminderPhone;
  IBOutlet UIButton *_btnPracticeReminderEmail;
  IBOutlet UITableViewCell *_celFriendAdded;
  IBOutlet UIButton *_btnFriendAddedPhone;
  IBOutlet UIButton *_btnFriendAddedEmail;
  IBOutlet UITableViewCell *_celFriendPassed;
  IBOutlet UIButton *_btnFriendPassedPhone;
  IBOutlet UIButton *_btnFriendPassedEmail;
}

- (IBAction)btnSendFeedbackPressed:(UIButton *)sender;
- (IBAction)btnLogoutPressed:(UIButton *)sender;
- (IBAction)swtSoundEffectsChanged:(UISwitch *)sender;
- (IBAction)swtListeningLessonsChanged:(UISwitch *)sender;
- (IBAction)swtFacebookChanged:(UISwitch *)sender;
- (IBAction)swtGooglePlusChanged:(UISwitch *)sender;
- (IBAction)btnNotificationModesPressed:(UIButton *)sender;

@end
