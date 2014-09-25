//
//  FTLessonLearningViewController.m
//  fanto
//
//  Created by Ethan on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLessonLearningViewController.h"

@interface FTLessonLearningViewController () {
  NSInteger _totalLessonsCount;
  NSInteger _currentLessonIndex;
  NSInteger _totalHeartsCount;
  NSInteger _currentHeartsCount;
}

- (void)setupViews;
- (void)updateHeaderViews;

@end

@implementation FTLessonLearningViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _totalLessonsCount = 20;
  _currentLessonIndex = 0;
  _totalHeartsCount = _currentHeartsCount = 4;
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  [self updateHeaderViews];
}

- (IBAction)btnClosePressed:(UIButton *)sender {
  _currentLessonIndex++;
  
  if (_currentLessonIndex % 5 == 0)
    _currentHeartsCount--;
  
  [self updateHeaderViews];
}

- (IBAction)btnHeartPotionPressed:(UIButton *)sender {
}

#pragma mark - Private methods
- (void)setupViews {
  _lblLessonsCount.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  [_btnHearts enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = YES;
    button.hidden = index >= _totalHeartsCount;
  }];
  
  CGRect frame = _vHearts.frame;
  frame.size.width = _totalHeartsCount * 30;
  frame.origin.x = self.view.frame.size.width - 15 - frame.size.width;
  _vHearts.frame = frame;
  
  frame = _btnHeartPotion.frame;
  frame.origin.x = _vHearts.frame.origin.x - frame.size.width - 13;
  _btnHeartPotion.frame = frame;
  
  [_btnProgressSegments enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(158, 158, 158)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(255, 187, 51)] forState:UIControlStateSelected];
    button.selected = NO;
    
    button.hidden = index >= _totalLessonsCount;
  }];
}

- (void)updateHeaderViews {
  _lblLessonsCount.text = [NSString stringWithFormat:@"%ld/%ld", (long)_currentLessonIndex+1, (long)_totalLessonsCount];
  
  [_btnHearts enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = index >= _totalHeartsCount - _currentHeartsCount;
  }];
  
  _imgAntProgressIndicator.hidden = _currentLessonIndex < 0;
  
  [_btnProgressSegments enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = index <= _currentLessonIndex;
    
    if (index == _currentLessonIndex) {
      CGPoint center = button.center;
      center.y -= 7;
      _imgAntProgressIndicator.center = center;
    }
  }];
}

@end
