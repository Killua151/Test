//
//  FTForgotPasswordViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/11/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTForgotPasswordViewController : BaseViewController <UITextFieldDelegate> {  
  IBOutlet UILabel *_lblInstructions;
  IBOutlet UIView *_vTextField;
  IBOutlet UITextField *_txtEmail;
  IBOutlet UIButton *_btnSubmit;
}

- (IBAction)btnSubmitPressed:(UIButton *)sender;

@end
