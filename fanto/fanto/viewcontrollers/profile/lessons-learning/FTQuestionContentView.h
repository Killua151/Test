//
//  FTQuestionContentView.h
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTQuestionContentView : UIView

@property (nonatomic, assign) id<FTLessonLearningDelegate> delegate;

- (void)setupViews;

@end
