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
  _totalHeartsCount = _currentHeartsCount = 3;
  
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
  UIAlertView *alertView =
  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning!", nil)
                             message:NSLocalizedString(@"Your progress will be lost. Are you sure to quit?", nil)
                            delegate:self
                   cancelButtonTitle:NSLocalizedString(@"No", nil)
                   otherButtonTitles:NSLocalizedString(@"Quit", nil), nil];
  
  [alertView show];
}

- (IBAction)btnHeartPotionPressed:(UIButton *)sender {
  _btnCheck.enabled = !_btnCheck.enabled;
}

- (IBAction)btnCheckPressed:(UIButton *)sender {
  if (_currentLessonIndex >= _totalLessonsCount-1)
    return;
  
  _currentLessonIndex++;
  
  if (_currentLessonIndex % 5 == 0)
    _currentHeartsCount--;
  
  [self updateHeaderViews];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    return;
  
  [self dismissViewController];
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
  
  CGFloat segmentWidth = [[_btnProgressSegments firstObject] frame].size.width;
  CGFloat segmentsGap = (self.view.frame.size.width - 30 - _totalLessonsCount * segmentWidth)/(_totalLessonsCount-1);
  
  __block CGRect buttonFrame;
  
  [_btnProgressSegments enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(158, 158, 158)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(255, 187, 51)] forState:UIControlStateSelected];
    button.selected = NO;
    
    button.hidden = index >= _totalLessonsCount;
    buttonFrame = button.frame;
    buttonFrame.origin.x = 15 + index * (buttonFrame.size.width + segmentsGap);
    button.frame = buttonFrame;
  }];
  
  _btnCheck.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [_btnCheck setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(153, 204, 0)] forState:UIControlStateNormal];
  [_btnCheck setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(102, 102, 102)] forState:UIControlStateDisabled];
  [_btnCheck setTitle:NSLocalizedString(@"Check", nil) forState:UIControlStateNormal];
  _btnCheck.superview.layer.cornerRadius = 4;
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
