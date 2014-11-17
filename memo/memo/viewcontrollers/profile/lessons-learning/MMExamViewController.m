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
#import "MAppSettings.h"

#define kTagQuitAlertView               0x01
#define kTagUseItemAlertView            0x02

@interface MMExamViewController () {
  NSInteger _totalHeartsCount;
  NSInteger _currentHeartsCount;
  NSDictionary *_availableItems;
  NSMutableDictionary *_viewedWords;
  BOOL _didAskUsingItem;
  
  CGFloat _innerPanGestureYPos;
  
  id _answerValue;
}

- (void)setupViews;
- (void)setupHeaderViews;
- (void)setupResultViews;
- (void)resetCounts;

- (void)resetResultViews;
- (void)showResultView:(BOOL)show
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
    _userFeedbacks = [NSMutableArray new];
    
    if (metadata[kParamTotalQuestions] != nil && [metadata[kParamTotalQuestions] isKindOfClass:[NSNumber class]])
      _totalQuestionsCount = [metadata[kParamTotalQuestions] integerValue];
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
  [[MMServerHelper defaultHelper] submitViewedWords:_viewedWords];
}

- (void)reloadContents {
  [self showResultView:NO forAnswerResult:YES withCorrectAnswer:nil underlineRanges:nil];
  [self removeCurrentQuestion];
}

- (void)gestureLayerDidTap {
  if (!_vResultPopup.hidden) {
    _currentQuestionIndex++;
    [self reloadContents];
  } else
    [_vQuestionContent gestureLayerDidTap];
}

- (void)questionContentViewGestureLayerDidTap {
  _vGestureLayer.hidden = YES;
}

- (IBAction)btnClosePressed:(UIButton *)sender {
  NSString *buttonEvent = @"placement test quit";
  
  if (_metadata[kParamType] != nil) {
    buttonEvent = [NSString stringWithFormat:@"%@ quit", _metadata[kParamType]];
    NSInteger questionNumber = 1;
    
    if (_metadata[kParamQuestionNumber] != nil)
      questionNumber = [_metadata[kParamQuestionNumber] integerValue];
      
    [Utils logAnalyticsForButton:buttonEvent andProperties:@{kParamQuestionNumber : @(questionNumber)}];
  } else
    [Utils logAnalyticsForButton:buttonEvent andProperties:@{kParamQuestionNumber : @(_currentQuestionIndex)}];
  
  
  [UIAlertView
   showWithTitle:MMLocalizedString(@"Warning!")
   message:MMLocalizedString(@"Your progress will be lost. Are you sure to quit?")
   cancelButtonTitle:MMLocalizedString(@"No")
   otherButtonTitles:@[MMLocalizedString(@"Quit")]
   callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
     if (buttonIndex == 0)
       return;
     
     [self dismissViewController];
   }];
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
  
  [[MMServerHelper defaultHelper] useItem:kItemHealthPotionId completion:^(NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    _availableItems = [MItem useItem:kItemHealthPotionId inAvailableItems:_availableItems];
    _btnHealthPotion.enabled = NO;
    _currentHeartsCount++;
    [self reloadContents];
  }];
}

- (IBAction)btnCheckPressed:(UIButton *)sender {
  if (sender.tag == YES)
    [self checkCurrentQuestion];
  else {
    _vGestureLayer.hidden = YES;
    _currentQuestionIndex++;
    [self reloadContents];
  }
}

- (void)prepareNextQuestion {  
  MBaseQuestion *question = _questionsData[_currentQuestionIndex];
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
  UIButton *btnProgressSegment = _btnProgressSegments[_currentQuestionIndex];
  btnProgressSegment.selected = YES;
  
  MBaseQuestion *question = _questionsData[_currentQuestionIndex];
  NSDictionary *checkResult = [question checkAnswer:_answerValue];
  
  BOOL answerResult = [checkResult[kParamAnswerResult] boolValue];
  NSString *correctAnswer = checkResult[kParamCorrectAnswer];
  NSArray *underlineRanges = checkResult[kParamUnderlineRanges];
  
  [self showResultView:YES
             forAnswerResult:answerResult
           withCorrectAnswer:correctAnswer
             underlineRanges:underlineRanges];
  
  _answersData[question.question_log_id] = @(answerResult);

  NSString *userAnswer = checkResult[kParamUserAnswer];
  
  if (userAnswer == nil || ![userAnswer isKindOfClass:[NSString class]])
    return;
  
  MAppSettings *appSettings = [MAppSettings sharedSettings];
  
  if (![appSettings.auto_feedback_types containsObject:question.type])
    return;
  
  [_userFeedbacks addObject:@{
                              kParamQuestionLogId : question.question_log_id,
                              kParamUserAnswer : userAnswer,
                              kParamAutoFeedback : @(YES)
                              }];
}

- (void)removeCurrentQuestion {
  // Out of hearts
  if (_currentHeartsCount == 0 && !_didAskUsingItem &&
      [MItem checkItemAvailability:kItemHealthPotionId inAvailableItems:_availableItems]) {
    NSInteger quantity = [_availableItems[kItemHealthPotionId] integerValue];
    NSString *message = [NSString stringWithFormat:
                         MMLocalizedString(@"You have %d Health Potion, do you want to use it?"), quantity];
    
    [UIAlertView
     showWithTitle:MMLocalizedString(@"Confirm item using")
     message:message
     cancelButtonTitle:MMLocalizedString(@"No")
     otherButtonTitles:@[MMLocalizedString(@"Yes, use it")]
     callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
       if (buttonIndex == 0) {
         _didAskUsingItem = YES;
         [self reloadContents];
         return;
       }
       
       [self btnHealthPotionPressed:nil];
     }];
    return;
  }

  if (_currentHeartsCount < 0) {
    [Utils playSoundEffect:kValueSoundEffectFail];
    
    [[MMServerHelper defaultHelper] submitFeedbacks:_userFeedbacks];
    
//    [[MMServerHelper sharedHelper] finishExamWithMetadata:_metadata
//                                               andResults:_answersData
//                                               completion:^(NSError *error) {}];
    
    MMFailLessonViewController *failLessonVC = [MMFailLessonViewController new];
    failLessonVC.delegate = self;
    [self presentViewController:failLessonVC animated:YES completion:NULL];
    return;
  }

  // Finish all questions
  if (_currentQuestionIndex >= _totalQuestionsCount) {
    [Utils playSoundEffect:kValueSoundEffectFinish];
    
    [[MMServerHelper defaultHelper] submitFeedbacks:_userFeedbacks];
    
    ShowHudForCurrentView();
    
    [[MMServerHelper defaultHelper]
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
  if (_currentQuestionIndex >= _totalQuestionsCount)
    return;
  
  _lblLessonsCount.text = [NSString stringWithFormat:@"%ld/%ld", (long)_currentQuestionIndex+1, (long)_totalQuestionsCount];
  
  [_btnHearts enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = index >= (_totalHeartsCount - _currentHeartsCount);
  }];
  
  [_btnProgressSegments enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    button.selected = index < _currentQuestionIndex;
  }];
  
  _imgAntProgressIndicator.hidden = _currentQuestionIndex < 0;
  
  UIButton *btnProgressSegment = _btnProgressSegments[_currentQuestionIndex];
  
  [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
    CGPoint center = btnProgressSegment.center;
    center.y -= 7;
    _imgAntProgressIndicator.center = center;
  }];
}

- (void)switchCheckButtonMode:(BOOL)useToCheck {
  _btnCheck.tag = useToCheck;
  [_btnCheck setTitle:(useToCheck ? MMLocalizedString(@"Check") : MMLocalizedString(@"Next"))
             forState:UIControlStateNormal];
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
  _currentQuestionIndex++;
  [self reloadContents];
}

- (void)userDidRetryLesson {
  void(^completionHandler)(NSString *, NSInteger, NSDictionary *, NSArray *, NSError *) =
  ^(NSString *examToken, NSInteger maxHeartsCount, NSDictionary *availableItems, NSArray *questions, NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    _metadata[kParamExamToken] = [NSString normalizedString:examToken];
    [_questionsData removeAllObjects];
    [_questionsData addObjectsFromArray:questions];
    
    [_answersData removeAllObjects];
    _totalHeartsCount = maxHeartsCount;
    _availableItems = availableItems;
    
    _didAskUsingItem = NO;
    
    [self resetCounts];
    [self updateHeaderViews];
    [self reloadContents];
  };
  
  ShowHudForCurrentView();
  
  if ([_metadata[kParamType] isEqualToString:kValueExamTypeLesson])
    [[MMServerHelper defaultHelper] startLesson:[_metadata[kParamLessonNumber] integerValue]
                                       inSkill:_metadata[kParamSkillId]
                                    completion:completionHandler];
  else if ([_metadata[kParamType] isEqualToString:kValueExamTypeShortcut])
    [[MMServerHelper defaultHelper] startShortcutTest:_metadata[kParamSkillId] completion:completionHandler];
  else if ([_metadata[kParamType] isEqualToString:kValueExamTypeStrengthenSkill])
    [[MMServerHelper defaultHelper] startStrengthenSkill:_metadata[kParamSkillId] completion:completionHandler];
  else if ([_metadata[kParamType] isEqualToString:kValueExamTypeCheckpoint])
    [[MMServerHelper defaultHelper] startCheckpointTestAtPosition:[_metadata[kParamCheckpointPosition] integerValue]
                                                      completion:completionHandler];
  else if ([_metadata[kParamType] isEqualToString:kValueExamTypeStrengthenAll])
    [[MMServerHelper defaultHelper] startStrengthenAll:completionHandler];
}

- (void)userDidViewWord:(NSString *)wordId {
  if (wordId == nil || ![wordId isKindOfClass:[NSString class]])
    return;
  
  if (_viewedWords == nil)
    _viewedWords = [NSMutableDictionary new];
  
  if (_viewedWords[wordId] == nil)
    _viewedWords[wordId] = @0;
  
  NSInteger viewedTimes = [_viewedWords[wordId] integerValue];
  _viewedWords[wordId] = @(viewedTimes+1);
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
  
  _lblAppVersion.font = [UIFont fontWithName:@"ClearSans" size:14];
  _lblAppVersion.text = [NSString stringWithFormat:@"v%@", CurrentBuildVersion()];
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
  CGFloat segmentsGap = (self.view.frame.size.width - 30 - _totalQuestionsCount * segmentWidth)/(_totalQuestionsCount-1);
  
  if (_totalQuestionsCount == 1)
    segmentsGap = 0;
  
  __block CGRect buttonFrame;
  
  [_btnProgressSegments enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(158, 158, 158)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromColor:UIColorFromRGB(255, 187, 51)] forState:UIControlStateSelected];
    button.selected = NO;
    
    button.hidden = index >= _totalQuestionsCount;
    buttonFrame = button.frame;
    buttonFrame.origin.x = 15 + index * (buttonFrame.size.width + segmentsGap);
    button.frame = buttonFrame;
  }];
}

- (void)setupResultViews {
  _vResultPopupBg.layer.cornerRadius = 5;
  _lblResultPopupMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblResultPopupMessage.text = @"";
  
  UIPanGestureRecognizer *panGesture =
  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
  panGesture.minimumNumberOfTouches = 1;
  panGesture.maximumNumberOfTouches = 1;
  panGesture.delegate = self;
  [_vResultPopup addGestureRecognizer:panGesture];
  
  [self resetResultViews];
}

- (void)resetCounts {
  // Reset count for normal exams only,
  // placement test's total questions count is responded from server
  if ([self isMemberOfClass:[MMExamViewController class]])
    _totalQuestionsCount = [_questionsData count];
  
  _currentQuestionIndex = 0;
  _currentHeartsCount = _totalHeartsCount;
  [_answersData removeAllObjects];
}

- (void)resetResultViews {
  CGRect frame = _vResultPopup.frame;
  frame.origin.y = _btnCheck.superview.frame.origin.y - 30 - frame.size.height;
  _vResultPopup.frame = frame;
  
  _vResultPopup.hidden = YES;
}

- (void)showResultView:(BOOL)show
       forAnswerResult:(BOOL)answerResult
     withCorrectAnswer:(NSString *)correctAnswer
       underlineRanges:(NSArray *)underlineRanges {
  if (!answerResult) {
    _currentHeartsCount--;
    [self updateHeaderViews];
  }
  
  if (show) {
    [Utils playSoundEffect:answerResult ? kValueSoundEffectCorrect : kValueSoundEffectHeartLost];
    
    _vResultPopup.alpha = 0;
    _vResultPopup.hidden = NO;
    [self switchCheckButtonMode:NO];
    [self updateResultViewWithResult:answerResult withCorrectAnswer:correctAnswer underlineRanges:underlineRanges];
  }
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vResultPopup.alpha = show;
   }
   completion:^(BOOL finished) {
     if (show)
       [self gestureLayerDidEnterEditingMode];
     else {
       [self resetResultViews];
       _vResultPopup.hidden = YES;
     }
   }];
}

- (void)updateResultViewWithResult:(BOOL)answerResult
                 withCorrectAnswer:(NSString *)correctAnswer
                   underlineRanges:(NSArray *)underlineRanges {
  _vResultPopupBg.backgroundColor = answerResult ? UIColorFromRGB(235, 255, 170) : UIColorFromRGB(255, 200, 200);
  
  NSString *iconName = answerResult ? @"img-lessons_learning-correct.png" : @"btn-lessons_learning-close.png";
  _imgResultPopupIcon.image = [UIImage imageNamed:iconName];
  
  _lblResultPopupMessage.textColor = _lblResultPopupAnswer.textColor =
  answerResult ? UIColorFromRGB(102, 153, 0) : UIColorFromRGB(129, 12, 21);
  
  // Incorrect or Correct with typos
  BOOL shouldShowAnswerLabel = !answerResult || [underlineRanges count] > 0;
  
  if (!answerResult)
    _lblResultPopupMessage.text = MMLocalizedString(@"Correct answer");
  else if (shouldShowAnswerLabel)
    _lblResultPopupMessage.text = MMLocalizedString(@"You have typos in your answer");
  else
    _lblResultPopupMessage.text = MMLocalizedString(@"Correct!");
  
  _lblResultPopupAnswer.hidden = !shouldShowAnswerLabel;
  
  if (shouldShowAnswerLabel) {
    if ([underlineRanges count] == 0)
      _lblResultPopupAnswer.text = correctAnswer;
    else
      for (NSValue *underlineRange in underlineRanges)
        [_lblResultPopupAnswer applyAttributedText:correctAnswer
                                           inRange:[underlineRange rangeValue]
                                    withAttributes:@{
                                                     NSUnderlineColorAttributeName : _lblResultPopupAnswer.textColor,
                                                     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                                                     }];
    
    [_lblResultPopupAnswer adjustToFitHeightAndConstrainsToHeight:46 relatedTo:_lblResultPopupMessage withDistance:5];
    
    BOOL answerInTwoLines = _lblResultPopupAnswer.frame.size.height > 23;
    
    CGRect frame = _lblResultPopupMessage.frame;
    frame.origin.y = answerInTwoLines ? 8 : 17;
    _lblResultPopupMessage.frame = frame;
    
    frame = _lblResultPopupAnswer.frame;
    frame.origin.y = _lblResultPopupMessage.frame.origin.y + _lblResultPopupMessage.frame.size.height + 5;
    _lblResultPopupAnswer.frame = frame;
  } else {
    CGPoint center = _lblResultPopupMessage.center;
    center.y = _lblResultPopupMessage.superview.frame.size.height/2 + kFontClearSansMarginTop;
    _lblResultPopupMessage.center = center;
  }
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
