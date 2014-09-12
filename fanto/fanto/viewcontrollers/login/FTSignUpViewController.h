//
//  FTSignUpViewController.h
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTSignUpViewController : BaseViewController <UITextFieldDelegate> {
  IBOutlet UITextField *_txtFullName;
  IBOutlet UITextField *_txtEmail;
  IBOutlet UITextField *_txtUsername;
  IBOutlet UITextField *_txtPassword;
}

- (IBAction)btnSubmitPressed:(UIButton *)sender;

@end
