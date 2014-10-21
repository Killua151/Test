//
//  FTSignUpViewController.h
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMSignUpViewController : BaseViewController <UITextFieldDelegate> {
  IBOutlet UIView *_vTextFields;
  IBOutlet UITextField *_txtFullName;
  IBOutlet UITextField *_txtEmail;
  IBOutlet UITextField *_txtUsername;
  IBOutlet UITextField *_txtPassword;
  IBOutlet UITextField *_txtConfirmPassword;
  IBOutlet UIButton *_btnSignUp;
  IBOutlet UIButton *_btnFacebook;
  IBOutlet UIButton *_btnGoogle;
}

- (IBAction)btnSignUpPressed:(UIButton *)sender;
- (IBAction)btnFacebookPressed:(UIButton *)sender;
- (IBAction)btnGooglePressed:(UIButton *)sender;

@end
