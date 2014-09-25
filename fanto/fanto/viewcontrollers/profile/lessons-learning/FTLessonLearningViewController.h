//
//  FTLessonLearningViewController.h
//  fanto
//
//  Created by Ethan on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTLessonLearningViewController : BaseViewController {
  IBOutlet UILabel *_lblLessonsCount;
  IBOutlet UIView *_vHearts;
  IBOutletCollection(UIButton) NSArray *_btnHearts;
  IBOutlet UIButton *_btnHeartPotion;
  IBOutlet UIImageView *_imgAntProgressIndicator;
  IBOutletCollection(UIButton) NSArray *_btnProgressSegments;
}

- (IBAction)btnClosePressed:(UIButton *)sender;
- (IBAction)btnHeartPotionPressed:(UIButton *)sender;

@end
