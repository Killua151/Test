//
//  FTLessonLearningViewController.m
//  fanto
//
//  Created by Ethan on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLessonLearningViewController.h"

#import "FTFormQuestionContentView.h"
#import "FTJudgeQuestionContentView.h"
#import "FTListenQuestionContentView.h"
#import "FTNameQuestionContentView.h"
#import "FTSelectQuestionContentView.h"
#import "FTSpeakQuestionContentView.h"
#import "FTTranslateQuestionContentView.h"

@interface FTLessonLearningViewController () {
  NSInteger _totalLessonsCount;
  NSInteger _currentLessonIndex;
  NSInteger _totalHeartsCount;
  NSInteger _currentHeartsCount;
  
  CGFloat _innerPanGestureYPos;
  UIView *_currentShowingResultView;
  
  FTQuestionContentView *_vQuestionContent;
}

- (void)setupViews;
- (void)setupHeaderViews;
- (void)setupResultViews;

- (void)updateHeaderViews;
- (void)resetResultViews;
- (void)setResultViewVisible:(BOOL)show forResult:(BOOL)correctAnswer;

- (void)prepareNextQuestion;
- (void)removeCurrentQuestion;

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture;

@end

@implementation FTLessonLearningViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _totalLessonsCount = 20;
  _currentLessonIndex = -1;
  _totalHeartsCount = _currentHeartsCount = 3;
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  [self setResultViewVisible:NO forResult:YES];
  _currentLessonIndex++;
  [self removeCurrentQuestion];
  [self updateHeaderViews];
}

- (void)gestureLayerDidTap {
  if (_currentShowingResultView != nil)
    [self reloadContents];
  else
    [_vQuestionContent gestureLayerDidTap];
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
  [self setResultViewVisible:YES forResult:YES];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    return;
  
  [self dismissViewController];
}

#pragma mark - FTLessonLearningDelegate methods
- (void)questionContentViewDidEnterEditingMode {
  [self gestureLayerDidEnterEditingMode];
}

- (void)questionContentViewDidUpdateAnswer:(BOOL)validAnswer {
  _btnCheck.enabled = validAnswer;
}

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  _innerPanGestureYPos = [gestureRecognizer locationInView:gestureRecognizer.view].y;
  return YES;
}

#pragma mark - Private methods
- (void)setupViews {
  [self setupHeaderViews];
  [self setupResultViews];
  
  _btnCheck.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [_btnCheck setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(153, 204, 0)] forState:UIControlStateNormal];
  [_btnCheck setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(102, 102, 102)] forState:UIControlStateDisabled];
  [_btnCheck setTitle:NSLocalizedString(@"Check", nil) forState:UIControlStateNormal];
  _btnCheck.superview.layer.cornerRadius = 4;
}

- (void)setupHeaderViews {
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
}

- (void)setupResultViews {
  _vResultCorrectBg.layer.cornerRadius = 5;
  _lblResultCorrectMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblResultCorrectMessage.text = NSLocalizedString(@"Correct!", nil);

  _vResultIncorrectBg.layer.cornerRadius = 5;
  _lblResultIncorrectMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblResultIncorrectMessage.text = NSLocalizedString(@"Correct answer", nil);
  
  _lblResultIncorrectAnswer.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  for (UIView *resultView in @[_vResultCorrect, _vResultIncorrect]) {
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
    [resultView addGestureRecognizer:panGesture];
  }
  
  [self resetResultViews];
}

- (void)updateHeaderViews {
  if (_currentLessonIndex >= _totalLessonsCount)
    return;
  
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

- (void)resetResultViews {
  CGRect frame = _vResultCorrect.frame;
  frame.origin.y = _btnCheck.superview.frame.origin.y - 30 - frame.size.height;
  _vResultCorrect.frame = _vResultIncorrect.frame = frame;
  
  _vResultCorrect.alpha = _vResultIncorrect.alpha = 0;
  _currentShowingResultView = nil;
}

- (void)setResultViewVisible:(BOOL)show forResult:(BOOL)correctAnswer {
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     if (show) {
       _currentShowingResultView = correctAnswer ? _vResultCorrect : _vResultIncorrect;
       _currentShowingResultView.alpha = 1;
     }
     else
       _vResultCorrect.alpha = _vResultIncorrect.alpha = 0;
   }
   completion:^(BOOL finished) {
     if (show)
       [self gestureLayerDidEnterEditingMode];
     else
       [self resetResultViews];
   }];
}

- (void)prepareNextQuestion {
//  NSArray *klasses = @[
//                       [FTFormQuestionContentView class],
//                       [FTJudgeQuestionContentView class],
//                       [FTListenQuestionContentView class],
//                       [FTNameQuestionContentView class],
//                       [FTSelectQuestionContentView class],
//                       [FTSpeakQuestionContentView class],
//                       [FTTranslateQuestionContentView class]
//                       ];
//  _vQuestionContent = [klasses[_currentLessonIndex%[klasses count]] new];
  _vQuestionContent = [FTFormQuestionContentView new];
  
  _vQuestionContent.delegate = self;
  _vQuestionContent.alpha = 0;
  _vQuestionContent.userInteractionEnabled = NO;
  [_vContentView addSubview:_vQuestionContent];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vQuestionContent.alpha = 1;
   }
   completion:^(BOOL finished) {
     _vQuestionContent.userInteractionEnabled = YES;
   }];
}

- (void)removeCurrentQuestion {
  _btnCheck.enabled = NO;
  
  if (_currentLessonIndex >= _totalLessonsCount)
    return;
  
  if ([_vContentView.subviews count] == 0) {
    [self prepareNextQuestion];
    return;
  }
  
  UIView *questionView = [_vContentView.subviews firstObject];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGRect frame = questionView.frame;
     frame.origin.x -= 320;
     questionView.frame = frame;
   }
   completion:^(BOOL finished) {
     [questionView removeFromSuperview];
     [self prepareNextQuestion];
   }];
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture {
  if (panGesture.state == UIGestureRecognizerStateBegan)
    panGesture.view.alpha = 0.2;
  else if (panGesture.state == UIGestureRecognizerStateEnded)
    panGesture.view.alpha = 1;
  
  CGPoint outterLocation = [panGesture locationInView:panGesture.view.superview];
  CGFloat viewHeight = panGesture.view.frame.size.height;
  
  CGRect frame = panGesture.view.frame;
  frame.origin.y = outterLocation.y - _innerPanGestureYPos;
  frame.origin.y = MAX(_lblLessonsCount.superview.frame.size.height,
                       MIN(_btnCheck.superview.frame.origin.y - viewHeight - 5, frame.origin.y));
  panGesture.view.frame = frame;
}

@end
