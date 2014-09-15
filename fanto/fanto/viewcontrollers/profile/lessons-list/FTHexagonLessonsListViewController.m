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
  UIView *lessonView = nil;
  
  for (UIView *subview in _vLessonsScrollView.subviews)
    if (subview.tag == _currentFocusedLessonIndex) {
      lessonView = subview;
      break;
    }
  
  if (lessonView == nil)
    return;
  
  CGFloat delta = ABS(_vLessonsScrollView.contentOffset.x - _currentFocusedLessonIndex * _vLessonsScrollView.frame.size.width);
  CGFloat scaleRatio = delta / kFocusedLessonWidth;
  
  CGRect frame = lessonView.frame;
  frame.size.width = kFocusedLessonWidth - (kFocusedLessonWidth - kNormalLessonWidth) * scaleRatio;
  frame.size.height = kFocusedLessonHeight - (kFocusedLessonHeight - kNormalLessonHeight) * scaleRatio;
  frame.origin.x = _vLessonsScrollView.frame.size.width * _currentFocusedLessonIndex + (_vLessonsScrollView.frame.size.width - frame.size.width)/2;
  frame.origin.y = _vLessonsScrollView.frame.size.height - frame.size.height;
  lessonView.frame = frame;
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
    frame.origin.x = _vLessonsScrollView.frame.size.width * index + (_vLessonsScrollView.frame.size.width - frame.size.width)/2;
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

- (void)testOut {
}

@end
