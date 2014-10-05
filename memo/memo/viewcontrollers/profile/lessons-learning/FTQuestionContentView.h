//
//  FTQuestionContentView.h
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBaseQuestion;

@interface FTQuestionContentView : UIView

@property (nonatomic, assign) id<FTLessonLearningDelegate> delegate;
@property (nonatomic, strong) MBaseQuestion *questionData;

- (id)initWithQuestion:(MBaseQuestion *)question;

- (void)setupViews;
- (void)gestureLayerDidTap;

@end
