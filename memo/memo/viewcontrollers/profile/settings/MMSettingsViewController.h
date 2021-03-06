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
  MMSwitch *_swtSoundEffects;
  
  IBOutlet UITableViewCell *_celListeningLessons;
  MMSwitch *_swtSpeakingLessons;
  
  IBOutlet UITableViewCell *_celFacebook;
  MMSwitch *_swtFacebook;
  
  IBOutlet UITableViewCell *_celGooglePlus;
  MMSwitch *_swtGooglePlus;
  
  IBOutletCollection(UILabel) NSArray *_lblTitles;
}

@property (nonatomic, strong) MUser *userData;

- (IBAction)btnSendFeedbackPressed:(UIButton *)sender;
- (IBAction)btnLogoutPressed:(UIButton *)sender;
- (IBAction)btnNotificationModesPressed:(UIButton *)sender;

@end
