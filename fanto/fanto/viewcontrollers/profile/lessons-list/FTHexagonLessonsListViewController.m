//
//  FTLessonsListViewController.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTHexagonLessonsListViewController.h"
#import "MLesson.h"

#define kNormalLessonWidth        230.f
#define kNormalLessonHeight       160.f
#define kFocusedLessonWidth       260.f
#define kFocusedLessonHeight      181.f

@interface FTHexagonLessonsListViewController () {
  BOOL _didReloadContent;
  NSArray *_lessonsData;
  NSInteger _currentFocusedLessonIndex;
}

- (void)setupLessonsScrollView;
- (void)updateFocusedLesson;
- (void)focusLesson:(UIView *)lessonView atIndex:(NSInteger)index focused:(BOOL)focused;
- (UIView *)lessonViewAtIndex:(NSInteger)lessonIndex;
- (void)scaleLessonView:(UIView *)lessonView withRatio:(CGFloat)scaleRatio;
- (void)testOut;

@end

@implementation FTHexagonLessonsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customTitleWithText:@"Ngày và giờ" color:[UIColor whiteColor]];
  [self customBackButton];
  [self customBarButtonWithImage:nil title:@"Kiểm tra" color:[UIColor whiteColor] target:self action:@selector(testOut) distance:-8];
  
  [self reloadContents];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customNavBarBgWithColor:nil];
}

- (void)reloadContents {
  _didReloadContent = YES;
  
  if (_skillData == nil || CGRectEqualToRect(_vLessonsScrollView.frame, CGRectZero))
    return;
  
  _lessonsData = @[[MLesson new], [MLesson new], [MLesson new], [MLesson new]];
  [self setupLessonsScrollView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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
  CGFloat scaleRatio = ABS(delta) / kFocusedLessonWidth;
  
  UIView *lessonView = [self lessonViewAtIndex:_currentFocusedLessonIndex];
  [self scaleLessonView:lessonView withRatio:-scaleRatio];
  
  // Calculate which lesson view is scaled up: 1 = right; -1 = left
  NSInteger scaleUpSide = delta > 0 ? 1 : (delta < 0 ? -1 : 0);
  
  if (scaleUpSide != 0) {
    lessonView = [self lessonViewAtIndex:_currentFocusedLessonIndex+scaleUpSide];
    [self scaleLessonView:lessonView withRatio:scaleRatio];
  }
}

#pragma mark - Private methods
- (void)setupLessonsScrollView {
  for (UIView *subview in _vLessonsScrollView.subviews)
    [subview removeFromSuperview];
  
  [_lessonsData enumerateObjectsUsingBlock:^(MLesson *lesson, NSUInteger index, BOOL *stop) {
    CGRect frame = _vLessonsScrollView.frame;
    frame.origin = CGPointMake(index * _vLessonsScrollView.frame.size.width, 0);
    UIView *lessonView = [[UIView alloc] initWithFrame:frame];
    lessonView.backgroundColor = [UIColor whiteColor];
    lessonView.tag = index;
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){CGPointZero, lessonView.frame.size}];
    label.text = [NSString stringWithFormat:@"%d", index];
    label.textAlignment = NSTextAlignmentCenter;
    [lessonView addSubview:label];
    [_vLessonsScrollView addSubview:lessonView];
  }];
  
  _vLessonsScrollView.contentSize = CGSizeMake([_lessonsData count] * _vLessonsScrollView.frame.size.width,
                                               _vLessonsScrollView.frame.size.height);
  
  UIView *lessonView = [_vLessonsScrollView.subviews firstObject];
  [self focusLesson:lessonView atIndex:lessonView.tag focused:YES];
}

- (void)updateFocusedLesson {
  NSInteger index = _vLessonsScrollView.contentOffset.x / _vLessonsScrollView.frame.size.width;
  
  for (UIView *lessonView in _vLessonsScrollView.subviews)
    [self focusLesson:lessonView atIndex:lessonView.tag focused:lessonView.tag == index];
}

- (void)focusLesson:(UIView *)lessonView atIndex:(NSInteger)index focused:(BOOL)focused {
  CGRect frame = lessonView.frame;
  
  if (focused) {
    frame.size = CGSizeMake(kFocusedLessonWidth, kFocusedLessonHeight);
    frame.origin.x = _vLessonsScrollView.frame.size.width * index +
    (_vLessonsScrollView.frame.size.width - frame.size.width)/2;
    frame.origin.y = _vLessonsScrollView.frame.size.height - frame.size.height;
    lessonView.backgroundColor = [UIColor whiteColor];
    [_vLessonsScrollView bringSubviewToFront:lessonView];
  } else {
    frame.size = _vLessonsScrollView.frame.size;
    frame.origin = CGPointMake(index * _vLessonsScrollView.frame.size.width, 0);
    lessonView.backgroundColor = [UIColor blackColor];
  }
  
  lessonView.frame = frame;
}

- (UIView *)lessonViewAtIndex:(NSInteger)lessonIndex {
  for (UIView *subview in _vLessonsScrollView.subviews)
    if (subview.tag == lessonIndex)
      return subview;
  
  return nil;
}

- (void)scaleLessonView:(UIView *)lessonView withRatio:(CGFloat)scaleRatio {
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
  
  frame.origin.x = _vLessonsScrollView.frame.size.width * lessonView.tag + (_vLessonsScrollView.frame.size.width - frame.size.width)/2;
  frame.origin.y = _vLessonsScrollView.frame.size.height - frame.size.height;
  lessonView.frame = frame;
}

- (void)testOut {
}

@end
