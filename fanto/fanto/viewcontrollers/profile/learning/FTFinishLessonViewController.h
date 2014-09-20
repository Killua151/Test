//
//  FTFinishLessonViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTEndLearningViewController.h"

@interface FTFinishLessonViewController : FTEndLearningViewController {
  IBOutlet UILabel *_lblFinishLessonMessage;
  IBOutlet UILabel *_lblHeartBonusMessage;
  IBOutlet UIButton *_btnShare;
  IBOutlet UIButton *_btnNext;
}

- (IBAction)btnSharePressed:(UIButton *)sender;
- (IBAction)btnNextPressed:(UIButton *)sender;

@end
