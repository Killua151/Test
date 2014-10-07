//
//  FTSaveProgressViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMEndLearningViewController.h"

@interface MMSaveProgressViewController : MMEndLearningViewController {
  IBOutlet UILabel *_lblMessage;
  IBOutlet UIImageView *_imgAnt;
  IBOutlet UILabel *_lblSubMessage;
  IBOutlet UIButton *_btnCreateProfile;
  IBOutlet UIButton *_btnCancel;
}

- (IBAction)btnCreateProfile:(UIButton *)sender;
- (IBAction)btnCancel:(UIButton *)sender;

@end
