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

#import "MMSortQuestionContentView.h"
#import "MMJudgeQuestionContentView.h"
#import "MMListenQuestionContentView.h"
#import "MMNameQuestionContentView.h"
#import "MMSelectQuestionContentView.h"
#import "MMSpeakQuestionContentView.h"
#import "MMTranslateQuestionContentView.h"

#import "MBaseQuestion.h"
#import "MUser.h"
#import "MItem.h"

#define kTagQuitAlertView               0x01
#define kTagUseItemAlertView            0x02

@interface MMExamViewController () {
  NSInteger _totalLessonsCount;
  NSInteger _totalHeartsCount;
  NSInteger _currentHeartsCount;
  NSDictionary *_availableItems;
  BOOL _didAskUsingItem;
  
  CGFloat _innerPanGestureYPos;
  UIView *_currentShowingResultView;
  
  id _answerValue;
}

- (void)setupViews;
- (void)setupHeaderViews;
- (void)setupResultViews;
- (void)resetCounts;

- (void)resetResultViews;
- (void)setResultViewVisible:(BOOL)show
             forAnswerResult:(BOOL)answerResult
           withCorrectAnswer:(NSString *)correctAnswer
             underlineRanges:(NSArray *)underlineRanges;

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture;
- (Class)questionContentViewKlassForQuestionType:(NSString *)questionType;

@end

@implementation MMExamViewController

- (id)initWithQuestions:(NSArray *)questions andMetadata:(NSDictionary *)metadata {
  if (self = [super init]) {
    _metadata = [NSMutableDictionary dictionaryWithDictionary:metadata];
    _questionsData = [NSMutableArray arrayWithArray:questions];
    _answersData = [NSMutableDictionary new];
  }
  
  return self;
}

- (id)initWithQuestions:(NSArray *)questions
         maxHeartsCount:(NSInteger)maxHeartsCount
         availableItems:(NSDictionary *)availableItems
            andMetadata:(NSDictionary *)metadata {
  if (self = [self initWithQuestions:questions andMetadata:metadata]) {
    _totalHeartsCount = maxHeartsCount;
    _availableItems = availableItems;
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
  [self setResultViewVisible:NO forAnswerResult:YES withCorrectAnswer:nil underlineRanges:nil];
  _currentLessonIndex++;
  [self removeCurrentQuestion];
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
  [[UIAlertView alloc] initWithTitle:MMLocalizedString(@"Warning!")
                             message:MMLocalizedString(@"Your progress will be lost. Are you sure to quit?")
                            delegate:self
                   cancelButtonTitle:MMLocalizedString(@"No")
                   otherButtonTitles:MMLocalizedString(@"Quit"), nil];
  
  alertView.tag = kTagQuitAlertView;
  [alertView show];
}

- (IBAction)btnHealthPotionPressed:(UIButton *)sender {
  if (_currentHeartsCount > 0) {
    [Utils showToastWithMessage:
     [NSString stringWithFormat:MMLocalizedString(@"You still have %d health remaining"), _currentHeartsCount]];
    return;
  }
  
  if (![MItem checkItemAvailability:kItemHealthPotionId inAvailableItems:_availableItems])
    return;
  
  ShowHudForCurrentView();
  
  [[MMServerHelper sharedHelper] useItem:kItemHealthPotionId completion:^(NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    _availableItems = [MItem useItem:kItemHealthPotionId inAvailableItems:_availableItems];
    _btnHealthPotion.enabled = NO;
    _currentHeartsCount++;
    [self updateHeaderViews];
  }];
}

- (IBAction)btnCheckPressed:(UIButton *)sender {
  if (sender.tag == YES)
    [self checkCurrentQuestion];
  else {
    _vGestureLayer.hidden = YES;
    [self reloadContents];
  }
}

- (void)prepareNextQuestion {  
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
     [self updateHeaderViews];
   }];
}

- (void)checkCurrentQuestion {
  MBaseQuestion *question = _questionsData[_currentLessonIndex];
  NSDictionary *checkResult = [question checkAnswer:_answerValue];
  
  BOOL answerResult = [checkResult[kParamAnswerResult] boolValue];
  NSString *correctAnswer = checkResult[kParamCorrectAnswer];
  NSArray *underlineRanges = checkResult[kParamUnderlineRanges];
  
  [self setResultViewVisible:YES
             forAnswerResult:answerResult
           withCorrectAnswer:correctAnswer
             underlineRanges:underlineRanges];
  
  NSString *userAnswer = checkResult[kParamUserAnswer];
  
  // Wrong answer, auto feedback
  if (!answerResult && userAnswer != nil)
    [[MMServerHelper sharedHelper] submitFeedbackInQuestion:question.question_log_id
                                                forSentence:userAnswer
                                                 completion:^(NSError *error) {}];
  
  _answersData[question.question_log_id] = @(answerResult);
}

- (void)removeCurrentQuestion {
  // Out of hearts
  if (_currentHeartsCount == 0 && !_didAskUsingItem &&
      [MItem checkItemAvailability:kItemHealthPotionId inAvailableItems:_availableItems]) {
    NSInteger quantity = [_availableItems[kItemHealthPotionId] integerValue];
    NSString *message = [NSString stringWithFormat:
                         MMLocalizedString(@"You have %d Health Potion, do you want to use it?"), quantity];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:MMLocalizedString(@"Confirm item using")
                              message:message
                              delegate:self
                              cancelButtonTitle:MMLocalizedString(@"No")
                              otherButtonTitles:MMLocalizedString(@"Yes, use it"), nil];
    
    alertView.tag = kTagUseItemAlertView;
    [alertView show];
    return;
  }

  if (_currentHeartsCount < 0) {
    [[MMServerHelper sharedHelper] finishExamWithMetadata:_metadata
                                               andResults:_answersData
                                               completion:^(NSError *error) {}];
    
    MMFailLessonViewController *failLessonVC = [MMFailLessonViewController new];
    failLessonVC.delegate = self;
    [self presentViewController:failLessonVC animated:YES completion:NULL];
    return;
  }

  // Finish all questions
  if (_currentLessonIndex >= _totalLessonsCount) {
    ShowHudForCurrentView();
    
    [[MMServerHelper sharedHelper]
     finishExamWithMetadata:_metadata
     andResults:_answersData
     completion:^(NSError *error) {
       HideHudForCurrentView();
       ShowAlertWithError(error);
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

- (void)updateHeaderViews {
  if (_currentLessonIndex >= _totalLessonsCount)
    return;
  
  _lblLessonsCount.text = [NSString stringWithFormat:@"%ld/%ld", (long)_currentLessonIndex+1, (long)_totalLessonsCount];
  
  [_btnHearts enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = index >= (_totalHeartsCount - _currentHeartsCount);
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

- (void)switchCheckButtonMode:(BOOL)useToCheck {
  _btnCheck.tag = useToCheck;
  [_btnCheck setTitle:(useToCheck ? MMLocalizedString(@"Check") : MMLocalizedString(@"Next"))
             forState:UIControlStateNormal];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == kTagQuitAlertView) {
    if (buttonIndex == 0)
      return;
    
    [self dismissViewController];
    return;
  }
  
  if (buttonIndex == 0) {
    _didAskUsingItem = YES;
    [self btnCheckPressed:nil];
    return;
  }
  
  [self btnHealthPotionPressed:nil];
}

#pragma mark - MMLessonLearningDelegate methods
- (void)questionContentViewDidEnterEditingMode:(BOOL)allowsTouchUnerneath {
  _vGestureLayer.touchUnderneathEnabled = allowsTouchUnerneath;
  [self gestureLayerDidEnterEditingMode];
}

- (void)questionContentViewDidUpdateAnswer:(BOOL)validAnswer withValue:(id)answerValue {
  _btnCheck.enabled = validAnswer;
  _answerValue = answerValue;
}

- (void)questionContentViewDidSkipAnswer {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserDefSpeakEnabled];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
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
  [_btnCheck setTitle:MMLocalizedString(@"Check") forState:UIControlStateNormal];
  _btnCheck.superview.layer.cornerRadius = 4;
}

- (void)setupHeaderViews {
  if (![self isMemberOfClass:[MMExamViewController class]]) {
    _vHeader.hidden = YES;
    return;
  }
  
  _lblLessonsCount.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  [_btnHearts enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = YES;
    button.hidden = index >= _totalHeartsCount;
  }];
  
  CGRect frame = _vHearts.frame;
  frame.size.width = _totalHeartsCount * 30;
  frame.origin.x = self.view.frame.size.width - 15 - frame.size.width;
  _vHearts.frame = frame;
  
  frame = _btnHealthPotion.frame;
  frame.origin.x = _vHearts.frame.origin.x - frame.size.width - 7;
  _btnHealthPotion.frame = frame;
  _btnHealthPotion.hidden = ![MItem checkItemAvailability:kItemHealthPotionId inAvailableItems:_availableItems];
  
  CGFloat segmentWidth = [[_btnProgressSegments firstObject] frame].size.width;
  CGFloat segmentsGap = (self.view.frame.size.width - 30 - _totalLessonsCount * segmentWidth)/(_totalLessonsCount-1);
  
  if (_totalLessonsCount == 1)
    segmentsGap = 0;
  
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
  _lblResultCorrectMessage.text = MMLocalizedString(@"Correct!");
  
  _vResultIncorrectBg.layer.cornerRadius = 5;
  _lblResultIncorrectMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblResultIncorrectMessage.text = MMLocalizedString(@"Correct answer");
  
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
  _currentHeartsCount = _totalHeartsCount;
  [_answersData removeAllObjects];
}

- (void)resetResultViews {
  CGRect frame = _vResultCorrect.frame;
  frame.origin.y = _btnCheck.superview.frame.origin.y - 30 - frame.size.height;
  _vResultCorrect.frame = _vResultIncorrect.frame = frame;
  
  _vResultCorrect.alpha = _vResultIncorrect.alpha = 0;
  _currentShowingResultView = nil;
}

- (void)setResultViewVisible:(BOOL)show
             forAnswerResult:(BOOL)answerResult
           withCorrectAnswer:(NSString *)correctAnswer
             underlineRanges:(NSArray *)underlineRanges {
  if (!answerResult) {
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
       _currentShowingResultView = answerResult ? _vResultCorrect : _vResultIncorrect;
       
       UILabel *lblResultMessage = nil;
       UILabel *lblResultAnswer = nil;
       BOOL shouldShowAnswerLabel = YES;
       
       // Incorrect answer, always show answer label
       if (!answerResult) {
         lblResultMessage = _lblResultIncorrectMessage;
         lblResultAnswer = _lblResultIncorrectAnswer;
       } else { // Correct
         // Correct with typos
         shouldShowAnswerLabel = [underlineRanges count] > 0;
         
         lblResultMessage = _lblResultCorrectMessage;
         lblResultAnswer = _lblResultCorrectAnswer;
         
         if (shouldShowAnswerLabel)
           lblResultMessage.text = MMLocalizedString(@"You have typos in your answer");
         else
           lblResultMessage.text = MMLocalizedString(@"Correct!");
       }
       
       lblResultAnswer.hidden = !shouldShowAnswerLabel;
       
       if (shouldShowAnswerLabel) {
         if ([underlineRanges count] == 0)
           lblResultAnswer.text = correctAnswer;
         else
           for (NSValue *underlineRange in underlineRanges)
             [lblResultAnswer applyAttributedText:correctAnswer
                                          inRange:[underlineRange rangeValue]
                                   withAttributes:@{
                                                    NSUnderlineColorAttributeName : lblResultAnswer.textColor,
                                                    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                                                    }];
         
         [lblResultAnswer adjustToFitHeightAndConstrainsToHeight:46 relatedTo:lblResultMessage withDistance:5];
         
         BOOL answerInTwoLines = lblResultAnswer.frame.size.height > 23;
         
         CGRect frame = lblResultMessage.frame;
         frame.origin.y = answerInTwoLines ? 8 : 17;
         lblResultMessage.frame = frame;
         
         frame = lblResultAnswer.frame;
         frame.origin.y = lblResultMessage.frame.origin.y + lblResultMessage.frame.size.height + 5;
         lblResultAnswer.frame = frame;
       } else {
         CGPoint center = lblResultMessage.center;
         center.y = lblResultMessage.superview.frame.size.height/2 + kFontClearSansMarginTop;
         lblResultMessage.center = center;
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
