//
//  FTLoginViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMLoginViewController : BaseViewController <UITextFieldDelegate> {
  IBOutlet UIView *_vTextFields;
  IBOutlet UITextField *_txtUsername;
  IBOutlet UITextField *_txtPassword;
  IBOutlet UIButton *_btnLogIn;
  IBOutlet UIButton *_btnForgotPassword;
  IBOutlet UIButton *_btnFacebook;
  IBOutlet UIButton *_btnGoogle;
}

- (IBAction)btnLoginPressed:(UIButton *)sender;
- (IBAction)btnForgotPasswordPressed:(UIButton *)sender;
- (IBAction)btnFacebookPressed:(UIButton *)sender;
- (IBAction)btnGooglePressed:(UIButton *)sender;

@end
