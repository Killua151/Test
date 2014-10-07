//
//  FTLessonLearningViewController.m
//  fanto
//
//  Created by Ethan on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMExamViewController.h"
#import "MMFailLessonViewController.h"
#import "MMFinishLessonViewController.h"

#import "MMFormQuestionContentView.h"
#import "MMJudgeQuestionContentView.h"
#import "MMListenQuestionContentView.h"
#import "MMNameQuestionContentView.h"
#import "MMSelectQuestionContentView.h"
#import "MMSpeakQuestionContentView.h"
#import "MMTranslateQuestionContentView.h"

#import "MBaseQuestion.h"
#import "MUser.h"

@interface MMExamViewController () {
  NSInteger _totalLessonsCount;
  NSInteger _currentLessonIndex;
  NSInteger _totalHeartsCount;
  NSInteger _currentHeartsCount;
  
  CGFloat _innerPanGestureYPos;
  UIView *_currentShowingResultView;
  
  MMQuestionContentView *_vQuestionContent;
  
  NSDictionary *_metadata;
  NSArray *_questionsData;
  NSMutableDictionary *_answersData;
  id _answerValue;
}

- (void)setupViews;
- (void)setupHeaderViews;
- (void)setupResultViews;
- (void)resetCounts;

- (void)updateHeaderViews;
- (void)resetResultViews;
- (void)setResultViewVisible:(BOOL)show withCorrectAnswer:(id)correctAnswer;
- (void)switchCheckButtonMode:(BOOL)useToCheck;

- (void)prepareNextQuestion;
- (void)checkCurrentQuestion;
- (void)removeCurrentQuestion;

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture;
- (Class)questionContentViewKlassForQuestionType:(NSString *)questionType;

@end

@implementation MMExamViewController

- (id)initWithQuestions:(NSArray *)questions andMetadata:(NSDictionary *)metadata {
  if (self = [super init]) {
    _metadata = metadata;
    _questionsData = questions;
    _answersData = [NSMutableDictionary new];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self resetCounts];
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [Utils preDownloadAudioFromUrls:[MBaseQuestion audioUrlsFromQuestions:_questionsData]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [Utils removePreDownloadedAudioWithOriginalUrls:[MBaseQuestion audioUrlsFromQuestions:_questionsData]];
}

- (void)reloadContents {
  [self setResultViewVisible:NO withCorrectAnswer:nil];
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

- (void)questionContentViewGestureLayerDidTap {
  _vGestureLayer.hidden = YES;
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
}

- (IBAction)btnCheckPressed:(UIButton *)sender {
  if (sender.tag == YES)
    [self checkCurrentQuestion];
  else {
    _vGestureLayer.hidden = YES;
    [self reloadContents];
  }
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    return;
  
  [self dismissViewController];
}

#pragma mark - MMLessonLearningDelegate methods
- (void)questionContentViewDidEnterEditingMode {
  [self gestureLayerDidEnterEditingMode];
}

- (void)questionContentViewDidUpdateAnswer:(BOOL)validAnswer withValue:(id)answerValue {
  _btnCheck.enabled = validAnswer;
  _answerValue = answerValue;
}

- (void)questionContentViewDidSkipAnswer {
  _vGestureLayer.hidden = YES;
  [self reloadContents];
}

- (void)userDidRetryLesson {
  [self resetCounts];
  [self reloadContents];
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

- (void)resetCounts {
  _totalLessonsCount = [_questionsData count];
  _currentLessonIndex = -1;
  _totalHeartsCount = _currentHeartsCount = 3;
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

- (void)setResultViewVisible:(BOOL)show withCorrectAnswer:(id)correctAnswer {
  BOOL answerIsCorrect = correctAnswer == nil;
  
  if (!answerIsCorrect) {
    _currentHeartsCount--;
    [self updateHeaderViews];
  }
  
  if (show)
    [self switchCheckButtonMode:NO];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     if (show) {
       _currentShowingResultView = answerIsCorrect ? _vResultCorrect : _vResultIncorrect;
       
       if (!answerIsCorrect) {
         _lblResultIncorrectAnswer.text = correctAnswer;
         [Utils adjustLabelToFitHeight:_lblResultIncorrectAnswer relatedTo:_lblResultIncorrectMessage withDistance:5];
         
         BOOL answerInTwoLines = _lblResultIncorrectAnswer.frame.size.height > 23;
         
         CGRect frame = _lblResultIncorrectMessage.frame;
         frame.origin.y = answerInTwoLines ? 8 : 17;
         _lblResultIncorrectMessage.frame = frame;
         
         frame = _lblResultIncorrectAnswer.frame;
         frame.origin.y = _lblResultIncorrectMessage.frame.origin.y + _lblResultIncorrectMessage.frame.size.height + 5;
         _lblResultIncorrectAnswer.frame = frame;
       }
       
       _currentShowingResultView.alpha = 1;
     } else
       _vResultCorrect.alpha = _vResultIncorrect.alpha = 0;
   }
   completion:^(BOOL finished) {
     if (show)
       [self gestureLayerDidEnterEditingMode];
     else
       [self resetResultViews];
   }];
}

- (void)switchCheckButtonMode:(BOOL)useToCheck {
  _btnCheck.tag = useToCheck;
  [_btnCheck setTitle:(useToCheck ? NSLocalizedString(@"Check", nil) : NSLocalizedString(@"Next", nil))
             forState:UIControlStateNormal];
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
  MBaseQuestion *question = _questionsData[_currentLessonIndex];
  Class questionContentViewKlass = [self questionContentViewKlassForQuestionType:question.type];
  _vQuestionContent = [[questionContentViewKlass alloc] initWithQuestion:question];
  
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

- (void)checkCurrentQuestion {
  MBaseQuestion *question = _questionsData[_currentLessonIndex];
  id result = [question checkAnswer:_answerValue];
  [self setResultViewVisible:YES withCorrectAnswer:result];
  
  _answersData[question.question_log_id] = @(result == nil ? YES : NO);
}

- (void)removeCurrentQuestion {
  // Out of hearts
  if (_currentHeartsCount < 0) {
    MMFailLessonViewController *failLessonVC = [MMFailLessonViewController new];
    failLessonVC.delegate = self;
    [self presentViewController:failLessonVC animated:YES completion:NULL];
    return;
  }
  
  // Finish all questions
  if (_currentLessonIndex >= _totalLessonsCount) {
    [Utils showHUDForView:self.view withText:nil];
    
    [[MMServerHelper sharedHelper]
     finishLesson:[_metadata[kParamLessonNumber] integerValue]
     inSkill:_metadata[kParamSkillId]
     withToken:_metadata[kParamExamToken]
     andResults:_answersData
     completion:^(NSError *error) {
       [Utils hideAllHUDsForView:self.view];
       ShowAlertWithError(error);
       
       DLog(@"%@", [MUser currentUser].lastReceivedBonuses);
       
       [self presentViewController:[MMFinishLessonViewController navigationController] animated:YES completion:NULL];
     }];
    
    return;
  }
  
  _btnCheck.enabled = NO;
  [self switchCheckButtonMode:YES];
  
  if ([_vContentView.subviews count] == 0) {
    [self prepareNextQuestion];
    return;
  }
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vQuestionContent.alpha = 0;
     CGRect frame = _vQuestionContent.frame;
     frame.origin.x -= 320;
     _vQuestionContent.frame = frame;
   }
   completion:^(BOOL finished) {
     [_vQuestionContent removeFromSuperview];
     _vQuestionContent = nil;
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

- (Class)questionContentViewKlassForQuestionType:(NSString *)questionType {
  return NSClassFromString([NSString stringWithFormat:@"MM%@QuestionContentView", [questionType capitalizedString]]);
}

@end
