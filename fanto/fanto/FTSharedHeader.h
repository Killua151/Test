//
//  FTSharedHeader.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSkill, MLesson;

@protocol FTSkillViewDelegate <NSObject>

@optional
- (void)skillViewDidSelectSkill:(MSkill *)skill;

@end

@protocol FTLessonViewDelegate <NSObject>

@optional
- (void)lessonViewDidSelectLesson:(MLesson *)lesson;

@end

@protocol FTActionSheetDelegate <NSObject>

@optional
- (void)actionSheetDidSelectAtIndex:(NSInteger)index;

@end

@protocol FTLessonLearningDelegate <NSObject>

@optional
- (void)questionContentViewDidEnterEditingMode;
- (void)questionContentViewDidUpdateAnswer:(BOOL)validAnswer;

@end

@protocol FTQuestionContentDelegate <NSObject>

@optional
- (void)selectQuestionButtonDidChanged:(BOOL)selected atIndex:(NSInteger)index;

@end