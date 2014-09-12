//
//  FTLoginViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"
#import <GooglePlus/GooglePlus.h>

@interface FTLoginViewController : BaseViewController <UITextFieldDelegate, GPPSignInDelegate> {
  IBOutlet UITextField *_txtUsername;
  IBOutlet UITextField *_txtPassword;
}

- (IBAction)btnLoginPressed:(UIButton *)sender;
- (IBAction)btnForgotPasswordPressed:(UIButton *)sender;
- (IBAction)btnFacebookPressed:(UIButton *)sender;
- (IBAction)btnGooglePressed:(UIButton *)sender;

@end
