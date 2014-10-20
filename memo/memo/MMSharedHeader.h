//
//  FTSharedHeader.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSkill, MLesson, MMSortQuestionAnswerTokenButton;

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
- (void)questionContentViewDidEnterEditingMode:(BOOL)allowsTouchUnerneath;
- (void)questionContentViewDidUpdateAnswer:(BOOL)validAnswer withValue:(id)answerValue;
- (void)questionContentViewDidSkipAnswer;
- (void)userDidRetryLesson;

@end

@protocol MMQuestionContentDelegate <NSObject>

@optional
- (void)selectQuestionButtonDidChanged:(BOOL)selected atIndex:(NSInteger)index;
- (void)formTokenButtonDidSelect:(MMSortQuestionAnswerTokenButton *)button;

@end

@protocol MMFindFriendDelegate <NSObject>

@optional
- (void)interactFriend:(NSString *)userId toFollow:(BOOL)follow atIndex:(NSInteger)index;

@end

@protocol MMShopDelegate <NSObject>

@optional
- (void)shopDidBuyItem:(NSString *)itemId;

@end