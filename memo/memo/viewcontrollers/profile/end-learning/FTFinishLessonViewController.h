//
//  FTFinishLessonViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTEndLearningViewController.h"

@interface FTFinishLessonViewController : FTEndLearningViewController <UIGestureRecognizerDelegate, FTActionSheetDelegate> {
  IBOutlet UILabel *_lblFinishLessonMessage;
  IBOutlet UILabel *_lblHeartBonusMessage;
  IBOutlet UIButton *_btnShare;
  IBOutlet UIButton *_btnNext;
  IBOutlet UIView *_vSetGoal;
  IBOutlet UILabel *_lblStreaksCount;
  IBOutlet UIButton *_btnSetGoal;
}

- (IBAction)btnSharePressed:(UIButton *)sender;
- (IBAction)btnNextPressed:(UIButton *)sender;
- (IBAction)btnSetGoalPressed:(UIButton *)sender;

@end
