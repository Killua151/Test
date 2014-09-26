//
//  FTJudgeQuestionView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTSelectQuestionContentView : UIView <FTLessonLearningDelegate> {
  IBOutlet UILabel *_lblQuestion;
}

@property (nonatomic, assign) id<FTLessonLearningDelegate> delegate;

@end
