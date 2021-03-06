//
//  FTFinishLessonViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMFinishLessonViewController.h"
#import "MMSkillsListViewController.h"
#import "MMCongratsViewController.h"
#import "MMFinishSkillViewController.h"
#import "MMSetGoalViewController.h"
#import "MMShareActionSheet.h"
#import "MUser.h"

@interface MMFinishLessonViewController () {
  MMLineChart *_lineChart;
  MMShareActionSheet *_vShare;
  CGFloat _innerPanGestureYPos;
}

- (void)addLineChart;
- (void)setupSetGoalView;
- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture;
- (void)presentLevelUpCongratsVC;

@end

@implementation MMFinishLessonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  [self addLineChart];
  [self setupSetGoalView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  NSDictionary *receivedBonuses = [MUser currentUser].lastReceivedBonuses;
  
  NSString *styledString = [NSString stringWithFormat:@"+%@ EXP", receivedBonuses[kParamFinishExamBonusExp]];
  NSString *message = [NSString stringWithFormat:MMLocalizedString(@"Lesson done! %@"), styledString];
  
  _lblFinishLessonMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [_lblFinishLessonMessage applyAttributedText:message
                                      onString:styledString
                                withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans" size:17]}];
  [_lblFinishLessonMessage adjustToFitHeight];
  
  _lblHeartBonusMessage.hidden = receivedBonuses[kParamHeartBonusExp] == nil ||
  ![receivedBonuses[kParamHeartBonusExp] isKindOfClass:[NSNumber class]] ||
  [receivedBonuses[kParamHeartBonusExp] integerValue] <= 0;
  
  if (!_lblHeartBonusMessage.hidden) {
    styledString = [NSString stringWithFormat:@"+%@ EXP", receivedBonuses[kParamHeartBonusExp]];
    message = [NSString stringWithFormat:MMLocalizedString(@"Health bonus %@"), styledString];
    
    _lblHeartBonusMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
    [_lblHeartBonusMessage applyAttributedText:message
                                      onString:styledString
                                withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans" size:17]}];
    [_lblHeartBonusMessage adjustToFitHeightAndRelatedTo:_lblFinishLessonMessage withDistance:5];
  }
  
  _btnShare.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnShare.layer.cornerRadius = 4;
  [_btnShare setTitle:MMLocalizedString(@"Share") forState:UIControlStateNormal];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:MMLocalizedString(@"Next") forState:UIControlStateNormal];
  
  styledString = [NSString stringWithFormat:MMLocalizedString(@"%d Combo days"), (long)[MUser currentUser].combo_days];
  message = [NSString stringWithFormat:MMLocalizedString(@"You have %@!"), styledString];
  _lblStreaksCount.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [_lblStreaksCount applyAttributedText:message
                               onString:styledString
                         withAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(255, 187, 51)}];
  
  _btnSetGoal.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSetGoal.layer.cornerRadius = 4;
  [_btnSetGoal setTitle:MMLocalizedString(@"Set goal") forState:UIControlStateNormal];
  
#if kTempDisableForClosedBeta
  _lblStreaksCount.center = CGPointMake(_lblStreaksCount.superview.frame.size.width/2,
                                        _lblStreaksCount.superview.frame.size.height/2 + kFontClearSansMarginTop);
  _btnSetGoal.hidden = YES;
#endif
}

- (IBAction)btnSharePressed:(UIButton *)sender {
  [_vShare show];
}

- (IBAction)btnNextPressed:(UIButton *)sender {
  if ([[MUser currentUser] finishExamLeveledUp] && [[MUser currentUser] finishExamLevel] > 0)
    [self presentLevelUpCongratsVC];
  else if ([[MUser currentUser] finishExamAffectedSkill] != nil)
    [self.navigationController pushViewController:[MMFinishSkillViewController new] animated:YES];
  else
    [self
     transitToViewController:[MMSkillsListViewController navigationController]
     completion:^(UIViewController *viewController) {
       MMSkillsListViewController *skillsListVC = ((UINavigationController *)viewController).viewControllers[0];
       [skillsListVC loadSkillsTree];
     }];
}

- (IBAction)btnSetGoalPressed:(UIButton *)sender {
  [self presentViewController:[MMSetGoalViewController navigationController] animated:YES completion:NULL];
}

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  _innerPanGestureYPos = [gestureRecognizer locationInView:gestureRecognizer.view].y;
  return YES;
}

#pragma mark - MMActionSheetDelegate methods
- (void)actionSheetDidSelectAtIndex:(NSInteger)index {
  [self presentShareViewControllerWithDefaultOption:(ShareOption)index];
}

#pragma mark - Private methods
- (void)addLineChart {
  if (_lineChart != nil) {
    [_lineChart removeFromSuperview];
    _lineChart = nil;
  }
  
  CGFloat delta = DeviceScreenIsRetina4Inch() ? 130 : 0;
  
  _lineChart = [[MUser currentUser] graphLineChartInFrame:
                CGRectMake(0, _lblHeartBonusMessage.frame.origin.y + 10, 320,
                           self.view.frame.size.height - _lblHeartBonusMessage.frame.origin.y - 135 - delta)];
  [self.view addSubview:_lineChart];
  [_lineChart drawChart];
}

- (void)setupSetGoalView {
  [self.view bringSubviewToFront:_vSetGoal];
  
  _vShare = [[MMShareActionSheet alloc] initInViewController:self];
  [self.view bringSubviewToFront:_vShare];
  
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _vSetGoal.frame;
    frame.origin.y = _btnShare.frame.origin.y - frame.size.height - 10;
    _vSetGoal.frame = frame;
  } else
    return;
  
  UIPanGestureRecognizer *panGesture =
  [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
  panGesture.minimumNumberOfTouches = 1;
  panGesture.maximumNumberOfTouches = 1;
  panGesture.delegate = self;
  
  [_vSetGoal addGestureRecognizer:panGesture];
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture {
  if (panGesture.state == UIGestureRecognizerStateBegan)
    panGesture.view.alpha = 0.2;
  else if (panGesture.state == UIGestureRecognizerStateEnded)
    panGesture.view.alpha = 1;
  
  CGPoint outterLocation = [panGesture locationInView:panGesture.view.superview];
  
  CGFloat viewHeight = panGesture.view.frame.size.height;
  CGFloat superviewHeight = panGesture.view.superview.frame.size.height;
  
  CGRect frame = panGesture.view.frame;
  frame.origin.y = outterLocation.y - _innerPanGestureYPos;
  frame.origin.y = MAX(44, MIN(superviewHeight - viewHeight, frame.origin.y));
  panGesture.view.frame = frame;
}

- (void)presentLevelUpCongratsVC {
  MMCongratsViewController *congratsVC = [MMCongratsViewController new];
  
  NSInteger level = [[MUser currentUser] finishExamLevel];
  NSString *currentCourseName = [[MUser currentUser] finishExamCurrentCourseName];
  
  NSString *subMessage = [NSString stringWithFormat:
                          MMLocalizedString(@"Now you've reached level %d in %@ course, let's keep practice!"),
                          level, currentCourseName];
  congratsVC.displayingData = @{
                                kParamMessage : MMLocalizedString(@"Congratulation! You've leveled up!"),
                                kParamSubMessage : subMessage
                                };
  
  [self presentViewController:[congratsVC parentNavigationController] animated:YES completion:NULL];
}

@end
