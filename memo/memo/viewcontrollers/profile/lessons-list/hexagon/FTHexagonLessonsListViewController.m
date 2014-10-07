//
//  FTLessonsListViewController.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHexagonLessonsListViewController.h"
#import "FTHexagonLessonView.h"
#import "MMExamViewController.h"
#import "MSkill.h"
#import "MLesson.h"
#import "MBaseQuestion.h"
#import "ISSpeechRecognitionResult.h"

#define kNormalLessonWidth        230.f
#define kNormalLessonHeight       160.f
#define kFocusedLessonWidth       260.f
#define kFocusedLessonHeight      181.f

@interface FTHexagonLessonsListViewController () {
  NSInteger _currentFocusedLessonIndex;
}

- (void)setupLessonsScrollView;
- (void)updateFocusedLesson;
- (void)focusLesson:(FTHexagonLessonView *)lessonView atIndex:(NSInteger)index focused:(BOOL)focused;
- (FTHexagonLessonView *)lessonViewAtIndex:(NSInteger)lessonIndex;
- (void)scaleLessonView:(FTHexagonLessonView *)lessonView withRatio:(CGFloat)scaleRatio;

@end

@implementation FTHexagonLessonsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
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
  
  FTHexagonLessonView *lessonView = [self lessonViewAtIndex:_currentFocusedLessonIndex];
  [self scaleLessonView:lessonView withRatio:-scaleRatio];
  
  // Calculate which lesson view is scaled up: 1 = right; -1 = left
  NSInteger scaleUpSide = delta > 0 ? 1 : (delta < 0 ? -1 : 0);
  
  if (scaleUpSide != 0) {
    lessonView = [self lessonViewAtIndex:_currentFocusedLessonIndex+scaleUpSide];
    [self scaleLessonView:lessonView withRatio:scaleRatio];
  }
}

#pragma mark - FTLessonViewDelegate methods
- (void)lessonViewDidSelectLesson:(MLesson *)lesson {
  [Utils recognizeWithCompletion:^(ISSpeechRecognitionResult *result, NSError *error) {
    DLog(@"%@ %f %@", result.text, result.confidence, error);
  }];
  return;
  
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [[MMServerHelper sharedHelper]
   startLesson:lesson.lesson_number
   inSkill:self.skillData._id
   completion:^(NSString *examToken, NSArray *questions, NSError *error) {
     [Utils hideAllHUDsForView:self.navigationController.view];
     ShowAlertWithError(error);
     
     MMExamViewController *examVC =
     [[MMExamViewController alloc] initWithQuestions:questions
                                         andMetadata:@{
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
                         [NSString stringWithFormat:@"img-skill_icon-%@-%@_big", self.skillData._id, suffix]];
  
  for (UIView *subview in _vLessonsScrollView.subviews)
    [subview removeFromSuperview];
  
  NSInteger lessonsCount = [self.skillData.lessons count];
  
  [self.skillData.lessons enumerateObjectsUsingBlock:^(MLesson *lesson, NSUInteger index, BOOL *stop) {
    FTHexagonLessonView *lessonView =
    [[FTHexagonLessonView alloc] initWithLessonNumber:lesson.lesson_number inSkill:self.skillData forTarget:self];
    
    CGRect frame = lessonView.frame;
    frame.origin = CGPointMake(index * _vLessonsScrollView.frame.size.width, 0);
    lessonView.frame = frame;
    [_vLessonsScrollView addSubview:lessonView];
  }];
  
  _vLessonsScrollView.contentSize = CGSizeMake(lessonsCount * _vLessonsScrollView.frame.size.width,
                                               _vLessonsScrollView.frame.size.height);
  _vLessonsScrollView.contentOffset = CGPointZero;
  
  FTHexagonLessonView *lessonView = [_vLessonsScrollView.subviews firstObject];
  [self focusLesson:lessonView atIndex:lessonView.index focused:YES];
}

- (void)updateFocusedLesson {
  NSInteger index = _vLessonsScrollView.contentOffset.x / _vLessonsScrollView.frame.size.width;
  
  for (FTHexagonLessonView *lessonView in _vLessonsScrollView.subviews)
    [self focusLesson:lessonView atIndex:lessonView.index focused:lessonView.index == index];
}

- (void)focusLesson:(FTHexagonLessonView *)lessonView atIndex:(NSInteger)index focused:(BOOL)focused {
  CGRect frame = lessonView.frame;
  
  if (focused) {
    frame.size = CGSizeMake(kFocusedLessonWidth, kFocusedLessonHeight);
    frame.origin.x = _vLessonsScrollView.frame.size.width * index +
    (_vLessonsScrollView.frame.size.width - frame.size.width)/2;
    frame.origin.y = _vLessonsScrollView.frame.size.height - frame.size.height;
    [_vLessonsScrollView bringSubviewToFront:lessonView];
  } else {
    frame.size = _vLessonsScrollView.frame.size;
    frame.origin = CGPointMake(index * _vLessonsScrollView.frame.size.width, 0);
  }
  
  lessonView.frame = frame;
  [lessonView refreshView];
}

- (FTHexagonLessonView *)lessonViewAtIndex:(NSInteger)lessonIndex {
  for (FTHexagonLessonView *lessonView in _vLessonsScrollView.subviews)
    if (lessonView.index == lessonIndex)
      return lessonView;
  
  return nil;
}

- (void)scaleLessonView:(FTHexagonLessonView *)lessonView withRatio:(CGFloat)scaleRatio {
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
