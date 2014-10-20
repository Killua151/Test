//
//  FTQuestionContentView.h
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBaseQuestion;

@interface MMQuestionContentView : UIView <TTTAttributedLabelDelegate>

@property (nonatomic, assign) id<MMLessonLearningDelegate> delegate;
@property (nonatomic, strong) MBaseQuestion *questionData;

- (id)initWithQuestion:(MBaseQuestion *)question;

- (void)setupViews;
- (void)gestureLayerDidTap;
- (TTTAttributedLabel *)cloneStyledQuestionLabelAs:(UILabel *)originalQuestionLabel;

@end
