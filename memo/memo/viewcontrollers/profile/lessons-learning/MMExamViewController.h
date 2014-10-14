//
//  FTLessonLearningViewController.h
//  fanto
//
//  Created by Ethan on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMExamViewController : BaseViewController <UIAlertViewDelegate, MMLessonLearningDelegate, UIGestureRecognizerDelegate> {
  IBOutlet UIView *_vHeader;
  IBOutlet UILabel *_lblLessonsCount;
  IBOutlet UIView *_vHearts;
  IBOutletCollection(UIButton) NSArray *_btnHearts;
  IBOutlet UIButton *_btnHeartPotion;
  IBOutlet UIImageView *_imgAntProgressIndicator;
  IBOutletCollection(UIButton) NSArray *_btnProgressSegments;
  
  IBOutlet UIView *_vContentView;
  IBOutlet UIButton *_btnCheck;
  
  IBOutlet UIView *_vResultCorrect;
  IBOutlet UIImageView *_imgResultCorrectBg;
  IBOutlet UIView *_vResultCorrectBg;
  IBOutlet UILabel *_lblResultCorrectMessage;
  IBOutlet UILabel *_lblResultCorrectAnswer;
  
  IBOutlet UIView *_vResultIncorrect;
  IBOutlet UIImageView *_imgResultIncorrectBg;
  IBOutlet UIView *_vResultIncorrectBg;
  IBOutlet UILabel *_lblResultIncorrectMessage;
  IBOutlet UILabel *_lblResultIncorrectAnswer;
}

- (id)initWithQuestions:(NSArray *)questions andMetadata:(NSDictionary *)metadata;
- (IBAction)btnClosePressed:(UIButton *)sender;
- (IBAction)btnHeartPotionPressed:(UIButton *)sender;
- (IBAction)btnCheckPressed:(UIButton *)sender;
- (void)questionContentViewGestureLayerDidTap;



@end
