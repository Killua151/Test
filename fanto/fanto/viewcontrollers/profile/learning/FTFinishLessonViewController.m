//
//  FTFinishLessonViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTFinishLessonViewController.h"
#import "FTFinishSkillViewController.h"
#import "FTSetGoalViewController.h"
#import "FTShareActionSheet.h"
#import "MUser.h"

@interface FTFinishLessonViewController () {
  FTLineChart *_lineChart;
  FTShareActionSheet *_vShare;
  CGFloat _innerPanGestureYPos;
}

- (void)addLineChart;
- (void)setupSetGoalView;
- (void)panGestureHandler:(UIPanGestureRecognizer *)panGesture;

@end

@implementation FTFinishLessonViewController

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
  NSString *styledString = @"+999 XP";
  NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Bài tập hoàn thành! %@", nil), styledString];
  
  _lblFinishLessonMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [Utils applyAttributedTextForLabel:_lblFinishLessonMessage
                            withText:message
                            onString:styledString
                      withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans" size:17]}];
  [Utils adjustLabelToFitHeight:_lblFinishLessonMessage];
  
  styledString = @"+1 XP";
  message = [NSString stringWithFormat:NSLocalizedString(@"Thưởng trái tim %@", nil), styledString];
  
  _lblHeartBonusMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [Utils applyAttributedTextForLabel:_lblHeartBonusMessage
                            withText:message
                            onString:styledString
                      withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans" size:17]}];
  [Utils adjustLabelToFitHeight:_lblHeartBonusMessage relatedTo:_lblFinishLessonMessage withDistance:5];
  
  _btnShare.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnShare.layer.cornerRadius = 4;
  [_btnShare setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
  
  styledString = @"3 ngày streak";
  message = [NSString stringWithFormat:NSLocalizedString(@"Bạn có %@!", nil), styledString];
  _lblStreaksCount.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [Utils applyAttributedTextForLabel:_lblStreaksCount
                            withText:message
                            onString:styledString
                      withAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(255, 187, 51)}];
  
  _btnSetGoal.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSetGoal.layer.cornerRadius = 4;
  [_btnSetGoal setTitle:NSLocalizedString(@"Set goal", nil) forState:UIControlStateNormal];
}

- (IBAction)btnSharePressed:(UIButton *)sender {
  DLog(@"invoke");
  [_vShare show];
}

- (IBAction)btnNextPressed:(UIButton *)sender {
  [self.navigationController pushViewController:[FTFinishSkillViewController new] animated:YES];
}

- (IBAction)btnSetGoalPressed:(UIButton *)sender {
  [self.navigationController presentViewController:[FTSetGoalViewController navigationController]
                                          animated:YES
                                        completion:NULL];
}

#pragma mark - UIGestureRecognizerDelegate methods
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  _innerPanGestureYPos = [gestureRecognizer locationInView:gestureRecognizer.view].y;
  return YES;
}

#pragma mark - FTActionSheetDelegate methods
- (void)actionSheetDidSelectAtIndex:(NSInteger)index {
  DLog(@"%ld", (long)index);
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
  
  _vShare = [[FTShareActionSheet alloc] initInViewController:self];
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
  CGPoint outterLocation = [panGesture locationInView:panGesture.view.superview];
  
  CGFloat viewHeight = panGesture.view.frame.size.height;
  CGFloat superviewHeight = panGesture.view.superview.frame.size.height;
  
  CGRect frame = panGesture.view.frame;
  frame.origin.y = outterLocation.y - _innerPanGestureYPos;
  frame.origin.y = MAX(44, MIN(superviewHeight - viewHeight, frame.origin.y));
  panGesture.view.frame = frame;
}

@end