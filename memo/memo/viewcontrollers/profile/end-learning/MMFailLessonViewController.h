//
//  FTFailLessonViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMEndLearningViewController.h"

@interface MMFailLessonViewController : MMEndLearningViewController {
  IBOutlet UILabel *_lblMessage;
  IBOutlet UIImageView *_imgAnt;
  IBOutlet UIButton *_btnRetry;
  IBOutlet UIButton *_btnQuit;
}

@property (nonatomic, assign) id<MMLessonLearningDelegate> delegate;

- (IBAction)btnRetryPressed:(UIButton *)sender;
- (IBAction)btnQuitPressed:(UIButton *)sender;

@end
