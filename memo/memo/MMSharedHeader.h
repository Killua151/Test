//
//  FTSharedHeader.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSkill, MLesson, MMFormAnswerTokenButton;

typedef enum FormAnswerTokenStatusEnum {
  FormAnswerTokenAvailable = 0,
  FormAnswerTokenAnswered
} FormAnswerTokenStatus;

typedef enum ShareOptionEnum {
  ShareOptionNone = -1,
  ShareOptionFacebook = 0,
  ShareOptionGoogle,
  ShareOptionTwitter
} ShareOption;

@protocol MMSkillViewDelegate <NSObject>

@optional
- (void)skillViewDidSelectSkill:(MSkill *)skill;

@end

@protocol MMLessonViewDelegate <NSObject>

@optional
- (void)lessonViewDidSelectLesson:(MLesson *)lesson;

@end

@protocol MMActionSheetDelegate <NSObject>

@optional
- (void)actionSheetDidSelectAtIndex:(NSInteger)index;

@end

@protocol MMLessonLearningDelegate <NSObject>

@optional
- (void)questionContentViewDidEnterEditingMode;
- (void)questionContentViewDidUpdateAnswer:(BOOL)validAnswer withValue:(id)answerValue;
- (void)questionContentViewDidSkipAnswer;
- (void)userDidRetryLesson;

@end

@protocol FTQuestionContentDelegate <NSObject>

@optional
- (void)selectQuestionButtonDidChanged:(BOOL)selected atIndex:(NSInteger)index;
- (void)formTokenButtonDidSelect:(MMFormAnswerTokenButton *)button;

@end