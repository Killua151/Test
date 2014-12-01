//
//  FTLessonsListViewController.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHexagonLessonsListViewController.h"
#import "MMHexagonLessonView.h"
#import "MMExamViewController.h"
#import "MSkill.h"
#import "MLesson.h"
#import "MBaseQuestion.h"

#define kNormalLessonWidth        230.f
#define kNormalLessonHeight       160.f
#define kFocusedLessonWidth       260.f
#define kFocusedLessonHeight      181.f

@interface MMHexagonLessonsListViewController () {
  NSInteger _currentFocusedLessonIndex;
}

- (void)setupLessonsScrollView;
- (void)updateFocusedLesson;
- (void)focusLesson:(MMHexagonLessonView *)lessonView focused:(BOOL)focused;
- (void)focusLessonAtIndex:(NSInteger)index focused:(BOOL)focused;
- (MMHexagonLessonView *)lessonViewAtIndex:(NSInteger)lessonIndex;
- (void)scaleLessonView:(MMHexagonLessonView *)lessonView withRatio:(CGFloat)scaleRatio;

@end

@implementation MMHexagonLessonsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _lblAppVersion.font = [UIFont fontWithName:@"ClearSans" size:14];
  _lblAppVersion.text = [NSString stringWithFormat:@"v%@", CurrentBuildVersion()];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customBackButtonWithSuffix:@"white"];
  [self customNavBarBgWithColor:nil];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  [super reloadContents];
  
  if (self.skillData == nil || CGRectEqualToRect(_vLessonsScrollView.frame, CGRectZero))
    return;
  
  self.view.backgroundColor = [self.skillData themeColor];
  [self setupLessonsScrollView];
}

- (UIColor *)navigationTextColor {
  return [UIColor whiteColor];
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  _currentFocusedLessonIndex = _vLessonsScrollView.contentOffset.x / _vLessonsScrollView.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self updateFocusedLesson];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (decelerate)
    return;
  
  [self updateFocusedLesson];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat delta = _vLessonsScrollView.contentOffset.x - _currentFocusedLessonIndex * _vLessonsScrollView.frame.size.width;
  CGFloat scaleRatio = ABS(delta) / kNormalLessonWidth;
  
  MMHexagonLessonView *lessonView = [self lessonViewAtIndex:_currentFocusedLessonIndex];
  [self scaleLessonView:lessonView withRatio:-scaleRatio];
  
  // Calculate which lesson view is scaled up: 1 = right; -1 = left
  NSInteger scaleUpSide = delta > 0 ? 1 : (delta < 0 ? -1 : 0);
  
  if (scaleUpSide != 0) {
    lessonView = [self lessonViewAtIndex:_currentFocusedLessonIndex+scaleUpSide];
    [self scaleLessonView:lessonView withRatio:scaleRatio];
  }
}

#pragma mark - MMLessonViewDelegate methods
- (void)lessonViewDidSelectLesson:(MLesson *)lesson {
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper]
   startLesson:lesson.lesson_number
   inSkill:self.skillData._id
   completion:^(NSString *examToken,
                NSInteger maxHeartsCount,
                NSDictionary *availableItems,
                NSArray *questions,
                NSError *error) {
     HideHudForCurrentView();
     ShowAlertWithError(error);
     
     MMExamViewController *examVC =
     [[MMExamViewController alloc] initWithQuestions:questions
                                      maxHeartsCount:maxHeartsCount
                                      availableItems:availableItems
                                         andMetadata:@{
                                                       kParamType : kValueExamTypeLesson,
                                                       kParamExamToken : [NSString normalizedString:examToken],
                                                       kParamLessonNumber : @(lesson.lesson_number),
                                                       kParamSkillId : self.skillData._id
                                                       }];
     [self presentViewController:examVC animated:YES completion:NULL];
   }];
}

#pragma mark - Private methods
- (void)setupLessonsScrollView {
  NSString *suffix = self.skillData.unlocked ? @"unlocked" : @"locked";
  _imgSkillIcon.image = [UIImage imageNamed:
                         [NSString stringWithFormat:@"img-skill_icon-%@-%@_big", self.skillData.icon_name, suffix]];
  _imgBgLaurea.hidden = ![self.skillData isFinished];
  
  for (UIView *subview in _vLessonsScrollView.subviews)
    [subview removeFromSuperview];
  
  NSInteger lessonsCount = [self.skillData.lessons count];
  
  [self.skillData.lessons enumerateObjectsUsingBlock:^(MLesson *lesson, NSUInteger index, BOOL *stop) {
    MMHexagonLessonView *lessonView =
    [[MMHexagonLessonView alloc] initWithLessonNumber:lesson.lesson_number inSkill:self.skillData forTarget:self];
    
    CGRect frame = lessonView.frame;
    frame.origin = CGPointMake(index * _vLessonsScrollView.frame.size.width, 0);
    lessonView.frame = frame;
    [_vLessonsScrollView addSubview:lessonView];
  }];
  
  _vLessonsScrollView.contentSize = CGSizeMake(lessonsCount * _vLessonsScrollView.frame.size.width,
                                               _vLessonsScrollView.frame.size.height);
  _currentFocusedLessonIndex = self.skillData.finished_lesson;

  if (_currentFocusedLessonIndex >= [self.skillData.lessons count])
    _currentFocusedLessonIndex = [self.skillData.lessons count]-1;
  
  [_vLessonsScrollView setContentOffset:CGPointMake(_currentFocusedLessonIndex * _vLessonsScrollView.frame.size.width, 0)
                               animated:YES];
  
  [self updateFocusedLesson];
}

- (void)updateFocusedLesson {
  NSInteger index = _vLessonsScrollView.contentOffset.x / _vLessonsScrollView.frame.size.width;
  
  for (MMHexagonLessonView *lessonView in _vLessonsScrollView.subviews)
    [self focusLesson:lessonView focused:lessonView.index == index];
}

- (void)focusLesson:(MMHexagonLessonView *)lessonView focused:(BOOL)focused {
  CGRect frame = lessonView.frame;
  
  if (focused) {
    frame.size = CGSizeMake(kFocusedLessonWidth, kFocusedLessonHeight);
    frame.origin.x = _vLessonsScrollView.frame.size.width * lessonView.index +
    (_vLessonsScrollView.frame.size.width - frame.size.width)/2;
    frame.origin.y = _vLessonsScrollView.frame.size.height - frame.size.height;
    [_vLessonsScrollView bringSubviewToFront:lessonView];
  } else {
    frame.size = _vLessonsScrollView.frame.size;
    frame.origin = CGPointMake(lessonView.index * _vLessonsScrollView.frame.size.width, 0);
  }
  
  lessonView.frame = frame;
  [lessonView refreshView];
}

- (void)focusLessonAtIndex:(NSInteger)index focused:(BOOL)focused {
  MMHexagonLessonView *lessonView = [self lessonViewAtIndex:index];
  [self focusLesson:lessonView focused:focused];
}

- (MMHexagonLessonView *)lessonViewAtIndex:(NSInteger)lessonIndex {
  for (MMHexagonLessonView *lessonView in _vLessonsScrollView.subviews)
    if (lessonView.index == lessonIndex)
      return lessonView;
  
  return nil;
}

- (void)scaleLessonView:(MMHexagonLessonView *)lessonView withRatio:(CGFloat)scaleRatio {
  if (lessonView == nil)
    return;
  
  CGRect frame = lessonView.frame;
  
  if (scaleRatio > 0) {
    frame.size.width = kNormalLessonWidth + (kFocusedLessonWidth - kNormalLessonWidth) * ABS(scaleRatio);
    frame.size.height = kNormalLessonHeight + (kFocusedLessonHeight - kNormalLessonHeight) * ABS(scaleRatio);
  } else {
    frame.size.width = kFocusedLessonWidth - (kFocusedLessonWidth - kNormalLessonWidth) * ABS(scaleRatio);
    frame.size.height = kFocusedLessonHeight - (kFocusedLessonHeight - kNormalLessonHeight) * ABS(scaleRatio);
  }
  
  if (scaleRatio == 1)
    frame.size = CGSizeMake(kFocusedLessonWidth, kFocusedLessonHeight);
  else if (scaleRatio == -1)
    frame.size = CGSizeMake(kNormalLessonWidth, kNormalLessonHeight);
  
  frame.origin.x = _vLessonsScrollView.frame.size.width * lessonView.index +
  (_vLessonsScrollView.frame.size.width - frame.size.width)/2;
  frame.origin.y = _vLessonsScrollView.frame.size.height - frame.size.height;
  lessonView.frame = frame;
}

@end
