//
//  FTFinishSkillViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMEndLearningViewController.h"

@interface MMFinishSkillViewController : MMEndLearningViewController {
  IBOutlet UILabel *_lblSkillName;
  IBOutlet UIImageView *_imgSkillStrength;
  IBOutlet UILabel *_lblMessage;
  IBOutlet UILabel *_lblSubMessage;
  IBOutlet UIButton *_btnShare;
  IBOutlet UIButton *_btnNext;
}

- (IBAction)btnSharePressed:(UIButton *)sender;
- (IBAction)btnNextPressed:(UIButton *)sender;

@end
