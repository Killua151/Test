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
}

- (void)setupViews;

@end

@implementation FTLessonLearningViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _totalLessonsCount = 20;
  _currentLessonIndex = 10;
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  [_btnProgressSegments enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = index <= _currentLessonIndex;
    
    if (index == _currentLessonIndex) {
      CGPoint center = button.center;
      center.y -= 7;
      _imgAntProgressIndicator.center = center;
    }
  }];
}

- (IBAction)btnClosePressed:(UIButton *)sender {
}

- (IBAction)btnHeartPotionPressed:(UIButton *)sender {
}

#pragma mark - Private methods
- (void)setupViews {
  _lblLessonsCount.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  for (UIButton *button in _btnHearts)
    button.selected = YES;
  
  [_btnProgressSegments enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(158, 158, 158)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(255, 187, 51)] forState:UIControlStateSelected];
    button.selected = NO;
    
    button.hidden = index >= _totalLessonsCount;
  }];
}

@end
