//
//  FTShareViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/23/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTShareViewController : BaseViewController <UITextViewDelegate> {
  IBOutlet UIImageView *_imgShareImage;
  IBOutlet UITextField *_txtPlaceholder;
  IBOutlet UITextView *_txtComment;
  IBOutlet UIButton *_btnFacebook;
  IBOutlet UIButton *_btnGoogle;
  IBOutlet UIButton *_btnTwitter;
  IBOutlet UIButton *_btnSubmit;
}

- (IBAction)btnSocialServicePressed:(UIButton *)sender;
- (IBAction)btnSubmitPressed:(UIButton *)sender;

@end
