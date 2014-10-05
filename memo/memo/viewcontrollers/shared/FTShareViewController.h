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
  IBOutletCollection(UIButton) NSArray *_btnShareOptions;
  IBOutlet UIButton *_btnSubmit;
}

- (id)initWithDefaultOption:(ShareOption)defaultOption;

- (IBAction)btnSocialServicePressed:(UIButton *)sender;
- (IBAction)btnSubmitPressed:(UIButton *)sender;

@end
