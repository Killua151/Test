//
//  FTSettingsViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTSettingsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
  IBOutlet UITableView *_tblSettings;
  IBOutlet UITableViewCell *_celAvatar;
  IBOutlet UITableViewCell *_celUsername;
  IBOutlet UITextField *_txtUsername;
  IBOutlet UITableViewCell *_celPassword;
  IBOutlet UITextField *_txtPassword;
  IBOutlet UITableViewCell *_celEmail;
  IBOutlet UITextField *_txtEmail;
}

@end
