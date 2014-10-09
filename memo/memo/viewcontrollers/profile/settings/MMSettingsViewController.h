//
//  FTSettingsViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@class MUser;

@interface MMSettingsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
  IBOutlet UITableView *_tblSettings;
  
  IBOutlet UITableViewCell *_celAvatar;
  IBOutlet UIButton *_btnAvatar;
  
  IBOutlet UITableViewCell *_celUsername;
  IBOutlet UITextField *_txtUsername;
  IBOutlet UITableViewCell *_celPassword;
  IBOutlet UITextField *_txtPassword;
  IBOutlet UITableViewCell *_celEmail;
  IBOutlet UITextField *_txtEmail;
  
  IBOutlet UITableViewCell *_celFeedbackLogOut;
  IBOutlet UIButton *_btnFeedback;
  IBOutlet UIButton *_btnLogOut;
  
  IBOutlet UITableViewCell *_celSoundEffects;
  KLSwitch *_swtSoundEffects;
  
  IBOutlet UITableViewCell *_celListeningLessons;
  KLSwitch *_swtListeningLessons;
  
  IBOutlet UITableViewCell *_celFacebook;
  KLSwitch *_swtFacebook;
  
  IBOutlet UITableViewCell *_celGooglePlus;
  KLSwitch *_swtGooglePlus;
  
  IBOutlet UITableViewCell *_celPracticeReminder;
  IBOutlet UIButton *_btnPracticeReminderPhone;
  IBOutlet UIButton *_btnPracticeReminderEmail;
  
  IBOutlet UITableViewCell *_celFriendAdded;
  IBOutlet UIButton *_btnFriendAddedPhone;
  IBOutlet UIButton *_btnFriendAddedEmail;
  
  IBOutlet UITableViewCell *_celFriendPassed;
  IBOutlet UIButton *_btnFriendPassedPhone;
  IBOutlet UIButton *_btnFriendPassedEmail;
  
  IBOutletCollection(UILabel) NSArray *_lblTitles;
}

@property (nonatomic, strong) MUser *userData;

- (IBAction)btnSendFeedbackPressed:(UIButton *)sender;
- (IBAction)btnLogoutPressed:(UIButton *)sender;
- (IBAction)btnNotificationModesPressed:(UIButton *)sender;

@end
