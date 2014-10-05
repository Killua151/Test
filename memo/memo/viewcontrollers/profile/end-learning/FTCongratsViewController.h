//
//  FTCongratsViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTEndLearningViewController.h"

@interface FTCongratsViewController : FTEndLearningViewController <FTActionSheetDelegate> {
  IBOutlet UIImageView *_imgAnt;
  IBOutlet UILabel *_lblMessage;
  IBOutlet UILabel *_lblSubMessage;
  IBOutlet UIButton *_btnShare;
  IBOutlet UIButton *_btnNext;
}

- (IBAction)btnSharePressed:(UIButton *)sender;
- (IBAction)btnNextPressed:(UIButton *)sender;

@end
