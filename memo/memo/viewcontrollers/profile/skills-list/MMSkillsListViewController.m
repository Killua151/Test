//
//  FTSkillsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSkillsListViewController.h"
#import "MMCheckpointTestCell.h"
#import "MMSkillCell.h"
#import "MMLessonsListViewController.h"
#import "MMShopViewController.h"
#import "MMProfileViewController.h"
#import "MMCoursesListViewController.h"
#import "MMHomeViewController.h"
#import "MMBeginPlacementTestViewController.h"
#import "MMExamViewController.h"
#import "MMAdsPopupView.h"
#import "MMAdsItemView.h"
#import "AppsFlyerTracker.h"
#import "MMVoucherPagePopup.h"
#import "MMAppDelegate.h"

#import "MUser.h"
#import "MSkill.h"
#import "MCheckpoint.h"
#import "MCrossSale.h"
#import "MAdsConfig.h"

#import "MMCongratsViewController.h"

@interface MMSkillsListViewController () {
  NSArray *_skillsData;
  MMLessonsListViewController *_lessonsListVC;
  UIButton *_currentStrengthenButton;
}

- (void)gotoProfile;
- (void)gotoShop;
- (void)setupViews;
- (void)animateSlideStrengthenButton:(BOOL)show;
- (void)fadeOutBeginningOptions:(void(^)())completion;
- (void)handleLoadingError:(NSError *)error;
- (void)reportBugs;
- (void)reloadAds:(NSString *)adsPosition;
- (void)getInAppMessages;

@end

@implementation MMSkillsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [Utils setupAnalyticsForCurrentUser];
  [Utils logAnalyticsForUserLoggedIn];
  [Utils logAnalyticsForEvent:kValueTrackingsEventSkillsTree];
  
  [self customNavBarBgWithColor:UIColorFromRGB(238, 238, 238)];
  [self customTitleWithText:[MUser currentUser].current_course_name color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil
                           title:MMLocalizedString(@"Profile")
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(gotoProfile)
                        distance:8];
  
  [self customBarButtonWithImage:nil
                           title:MMLocalizedString(@"Plaza")
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(gotoShop)
                        distance:-8];
  
  [[MMServerHelper crossSaleHelper] getRunningAds];
  [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self getInAppMessages];
  [self checkLatestVersion];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _lessonsListVC = nil;
}

- (void)reloadContents {
  MUser *currentUser = [MUser currentUser];
  
  [self customTitleWithText:currentUser.current_course_name color:[UIColor blackColor]];
  _vBeginningOptions.hidden = !currentUser.is_beginner;
  
#if !kClosedBetaErrorFeedbackMode
  _vStrengthenButton.hidden = currentUser.is_beginner;
#endif

#if kTempDisableForClosedBeta && !kClosedBetaErrorFeedbackMode
  _vStrengthenButton.hidden = YES;
#endif
  
  _skillsData = [currentUser skillsTree];
  [_tblSkills reloadData];
}

- (void)displayCrossSaleAds {
  [_adsConfigsData enumerateKeysAndObjectsUsingBlock:^(NSString *position, MAdsConfig *adsConfig, BOOL *stop) {
    [[MCrossSale sharedModel]
     tryToLoadHtmlForAds:adsConfig
     forKey:position
     withCompletion:^(NSString *key, BOOL success) {
       MAdsConfig *aAdsConfig = _adsConfigsData[key];
       aAdsConfig.loaded = success;
       [self reloadAds:key];
     }];
  }];
}

- (IBAction)btnBeginnerPressed:(UIButton *)sender {
  [_tblSkills scrollRectToVisible:(CGRect){CGPointZero, _tblSkills.bounds.size} animated:YES];
  [self fadeOutBeginningOptions:NULL];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self skillViewDidSelectSkill:[[MUser currentUser] firstSkill]];
  });
}

- (IBAction)btnPlacementTestPressed:(UIButton *)sender {
  [self presentViewController:[MMBeginPlacementTestViewController navigationController] animated:YES completion:NULL];
}

- (IBAction)btnStrengthenPressed:(UIButton *)sender {
#if kClosedBetaErrorFeedbackMode
  [self reportBugs];
  return;
#endif
  
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper]
   startStrengthenAll:^(NSString *examToken,
                        NSInteger maxHeartsCount,
                        NSDictionary *availableItems,
                        NSArray *questions,
                        NSError *error) {
     HideHudForCurrentView();
     ShowAlertWithError(error);
     
     MMExamViewController *examVC =
     [[MMExamViewController alloc] initWithQuestions:questions
                                      maxHeartsCount:maxHeartsCount
                                      availableItems:availableItems
                                         andMetadata:@{
                                                       kParamType : kValueExamTypeStrengthenAll,
                                                       kParamExamToken : [NSString normalizedString:examToken]
                                                       }];
     
     [self presentViewController:examVC animated:YES completion:NULL];
   }];
}

- (void)loadSkillsTree {
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper] getUserProfile:^(NSDictionary *userData, NSError *error) {
    HideHudForCurrentView();
    
    if (error != nil) {
      [self handleLoadingError:error];
      return;
    }
    
    [self reloadContents];
    [self checkToDisplayAds];
  }];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_skillsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  if (![skills isKindOfClass:[NSArray class]]) {
    MMCheckpointTestCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  NSStringFromClass([MMCheckpointTestCell currentCheckpointTestCellClass])];
    
    if (cell == nil)
      cell = [[MMCheckpointTestCell currentCheckpointTestCellClass] new];
    
    [cell updateCellWithData:(MBase *)@(indexPath.row)];
    
    NSInteger order = [[MUser currentUser] checkpointOrderForCheckpoint:indexPath.row];
    NSString *checkpointPosition = [NSString stringWithFormat:@"ios_checkpoint_%ld", (long)order];
    [cell displayAds:_adsConfigsData[checkpointPosition]];
    
    return cell;
  }
  
  NSString *reuseIdentifier = [MMSkillCell reuseIdentifierForSkills:skills];
  
  MMSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  
  if (cell == nil)
    cell = [[[MMSkillCell currentSkillCellClass] alloc] initWithReuseIdentifier:reuseIdentifier
                                                                      withTotal:[skills count]
                                                                       inTarget:self];
  
  [cell updateCellWithSkills:skills];
  
  // iOS 7.0.4 hacks
  // the cell's content view's superview (UITableViewCellScrollView) implicitly set clipsToBounds to YES
  if (NSClassFromString(@"UITableViewCellScrollView") != nil &&
      [cell.contentView.superview isKindOfClass:[NSClassFromString(@"UITableViewCellScrollView") class]])
    [cell.contentView.superview setClipsToBounds:NO];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  if (![skills isKindOfClass:[NSArray class]]) {
    NSInteger order = [[MUser currentUser] checkpointOrderForCheckpoint:indexPath.row];
    NSString *checkpointPosition = [NSString stringWithFormat:@"ios_checkpoint_%ld", (long)order];
    MAdsConfig *adsConfig = _adsConfigsData[checkpointPosition];
    
    return [[MMCheckpointTestCell currentCheckpointTestCellClass] heightToFitWithData:nil] +
    (adsConfig.loaded ? adsConfig.height : 0);
  }
  
  return [[MMSkillCell currentSkillCellClass] heightToFitWithData:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  if ([skills isKindOfClass:[NSArray class]])
    return;
  
  MCheckpoint *checkpoint = [[MUser currentUser] checkpointForPosition:indexPath.row];
  
  NSInteger numberOfLockedSkills = [[MUser currentUser] numberOfLockedSkillsForCheckpoint:indexPath.row];
  
  if (numberOfLockedSkills <= 0 || checkpoint.remaining_test_times <= 0)
    return;
  
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper]
   startCheckpointTestAtPosition:checkpoint.row
   completion:^(NSString *examToken,
                NSInteger maxHeartsCount,
                NSDictionary *availableItems,
                NSArray *questions,
                NSError *error) {
     HideHudForCurrentView();
     ShowAlertWithError(error);
     
     MMExamViewController *examVC =
     [[MMExamViewController alloc] initWithQuestions:questions
                                      maxHeartsCount:maxHeartsCount
                                      availableItems:availableItems
                                         andMetadata:@{
                                                       kParamType : kValueExamTypeCheckpoint,
                                                       kParamExamToken : [NSString normalizedString:examToken],
                                                       kParamCheckpointPosition : @(checkpoint.row)
                                                       }];
     
     [self presentViewController:examVC animated:YES completion:NULL];
   }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self animateSlideStrengthenButton:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self animateSlideStrengthenButton:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (decelerate)
    return;
  
  [self animateSlideStrengthenButton:YES];
}

#pragma mark - MMSkillViewDelegate methods
- (void)skillViewDidSelectSkill:(MSkill *)skill {
  if (_lessonsListVC == nil)
    _lessonsListVC = [[MMLessonsListViewController currentLessonsListClass] new];
  
  _lessonsListVC.skillData = skill;
  [self.navigationController pushViewController:_lessonsListVC animated:YES];
  [_lessonsListVC reloadContents];
}

#pragma mark - Private methods
- (void)gotoProfile {
  [self presentViewController:[MMProfileViewController navigationController] animated:YES completion:NULL];
}

- (void)gotoShop {
#if kTestVoucherAds
  MMCongratsViewController *congratsVC = [MMCongratsViewController new];
  
  congratsVC.displayingData = @{
                                kParamMessage : MMLocalizedString(@"Congratulation! You've leveled up!"),
                                kParamSubMessage : @"Test"
                                };
  
  [self presentViewController:[congratsVC parentNavigationController] animated:YES completion:NULL];
  return;
#endif
  
  [self presentViewController:[MMShopViewController navigationController] animated:YES completion:NULL];
}

- (void)setupViews {
  [MUser currentUser].lastReceivedBonuses = nil;
  
  _btnHexagonStrengthen.hidden = _btnShieldStrengthen.hidden = YES;
  
  _currentStrengthenButton = kHexagonThemeDisplayMode ? _btnHexagonStrengthen : _btnShieldStrengthen;
  _currentStrengthenButton.hidden = NO;
  _currentStrengthenButton.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
  [_currentStrengthenButton setTitle:MMLocalizedString(@"Strengthen skills") forState:UIControlStateNormal];
  
#if kClosedBetaErrorFeedbackMode
  [_currentStrengthenButton setTitle:@"BÁO LỖI - GÓP Ý" forState:UIControlStateNormal];
#endif
  
  UIImage *maskingImage = [UIImage imageNamed:@"img-placement_test-icon.png"];
  
  for (UIView *iconBg in _vIconsBg) {
    CALayer *maskingLayer = [CALayer layer];
    maskingLayer.frame = iconBg.bounds;
    [maskingLayer setContents:(id)[maskingImage CGImage]];
    [iconBg.layer setMask:maskingLayer];
  }
  
  _lblBeginnerTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblBeginnerTitle.text = MMLocalizedString(@"Are you a beginner?");
  
  _lblBeginnerSubTitle.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblBeginnerSubTitle.text = MMLocalizedString(@"Start here with the Basics");
  
  _lblPlacementTestTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblPlacementTestTitle.text = MMLocalizedString(@"Not a beginner?");
  
  _lblPlacementTestSubTitle.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblPlacementTestSubTitle.text = MMLocalizedString(@"Try this Placement Test");
  
  CGFloat footerViewDelta = kHexagonThemeDisplayMode ? 52 : 22;
  _tblSkills.tableFooterView =
  [[UIView alloc] initWithFrame:
   (CGRect){CGPointZero, (CGSize){_tblSkills.frame.size.width, _vStrengthenButton.frame.size.height + footerViewDelta}}];
  
#if kTempDisableForClosedBeta && !kClosedBetaErrorFeedbackMode
  _vStrengthenButton.hidden = YES;
#else
  [self animateSlideStrengthenButton:NO];
#endif
}

- (void)animateSlideStrengthenButton:(BOOL)show {
#if kTempDisableForClosedBeta && !kClosedBetaErrorFeedbackMode
  return;
#endif
  
#if !kClosedBetaErrorFeedbackMode
  if ([MUser currentUser].is_beginner)
    return;
#endif
  
  if (show) {
    [UIView
     animateWithDuration:kDefaultAnimationDuration*2
     delay:0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
       CGRect frame = _vStrengthenButton.frame;
       frame.origin.y = _tblSkills.frame.origin.y + _tblSkills.frame.size.height - _vStrengthenButton.frame.size.height - 15;
       _vStrengthenButton.frame = frame;
     }
     completion:^(BOOL finished) {
       _currentStrengthenButton.enabled = YES;
     }];

    return;
  }
  
  _currentStrengthenButton.enabled = NO;
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration*2
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGRect frame = _vStrengthenButton.frame;
     frame.origin.y = _tblSkills.frame.origin.y + _tblSkills.frame.size.height + 15;
     _vStrengthenButton.frame = frame;
   }
   completion:^(BOOL finished) {
   }];
}

- (void)fadeOutBeginningOptions:(void (^)())completion {
  [self animateSlideStrengthenButton:YES];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration*2
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vBeginningOptions.alpha = 0;
   }
   completion:^(BOOL finished) {
     [_vBeginningOptions removeFromSuperview];
     
     if (completion != NULL)
       completion();
   }];
}

- (void)handleLoadingError:(NSError *)error {
  if ([error errorCode] == 400) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self transitToViewController:[MMCoursesListViewController navigationController] completion:NULL];
    });
    
    return;
  }
  
  [UIAlertView
   showWithTitle:[NSString stringWithFormat:MMLocalizedString(@"Error %d"), [error errorCode]]
   message:[error errorMessage]
   cancelButtonTitle:MMLocalizedString(@"Log out")
   otherButtonTitles:@[MMLocalizedString(@"Retry")]
   callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
     if (buttonIndex == 0) {
       [MUser logOutCurrentUser];
       [self transitToViewController:[MMHomeViewController navigationController] completion:NULL];
       return;
     }
     
     [self loadSkillsTree];
   }];
}

- (void)reportBugs {
  [UIAlertView
   showWithTitle:@"Báo lỗi Memo"
   message:@"Hãy giúp Memo tốt hơn nữa nhé :)"
   cancelButtonTitle:@"Thôi"
   otherButtonTitles:@[@"Gửi"]
   style:UIAlertViewStylePlainTextInput
   callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
     if (buttonIndex == 0)
       return;
     
     UITextField *textField = [alertView textFieldAtIndex:0];
     
     if (textField.text == nil || ![textField.text validateBlank]) {
       [self reportBugs];
       return;
     }
     
     ShowHudForCurrentView();
     [[MMServerHelper apiHelper] reportBug:textField.text completion:^(NSError *error) {
       HideHudForCurrentView();
       ShowAlertWithError(error);
       [UIAlertView showWithTitle:nil andMessage:@"Gửi thành công"];
     }];
   }];
}

- (void)reloadAds:(NSString *)adsPosition {
  MAdsConfig *adsConfig = _adsConfigsData[adsPosition];
  
  if (adsConfig == nil || ![adsConfig isKindOfClass:[MAdsConfig class]])
    return;
  
  if ([adsPosition isEqualToString:kValueAdsPositionTop]) {
    MMAdsItemView *vAdsPopup = [[MMAdsItemView alloc] initWithAds:adsConfig];
    
    CGRect frame = vAdsPopup.frame;
    frame.origin = CGPointZero;
    vAdsPopup.frame = frame;
    
    frame = _tblSkills.frame;
    frame.origin.y = vAdsPopup.frame.size.height;
    frame.size.height -= vAdsPopup.frame.size.height;
    _tblSkills.frame = frame;
    
    [_tblSkills.superview addSubview:vAdsPopup];
    
    frame = _lblAppVersion.superview.frame;
    frame.origin.y += vAdsPopup.frame.size.height;
    _lblAppVersion.superview.frame = frame;
    
    return;
  }
  
  if ([adsPosition isEqualToString:kValueAdsPositionBottom]) {
    MMAdsItemView *vAdsPopup = [[MMAdsItemView alloc] initWithAds:adsConfig];
    
    CGRect frame = _tblSkills.frame;
    frame.size.height -= vAdsPopup.frame.size.height;
    _tblSkills.frame = frame;
    
    frame = vAdsPopup.frame;
    frame.origin.y = _tblSkills.frame.origin.y + _tblSkills.frame.size.height;
    vAdsPopup.frame = frame;
    
    [_tblSkills.superview addSubview:vAdsPopup];
    
    return;
  }
  
  if ([adsPosition isEqualToString:kValueAdsPositionCenter]) {
    MMAdsPopupView *vAdsPopup = [[MMAdsPopupView alloc] initWithAds:adsConfig];
    [[self mainView] addSubview:vAdsPopup];
    return;
  }
  
  if ([adsPosition isEqualToString:kValueAdsPositionCheckpoint1] ||
      [adsPosition isEqualToString:kValueAdsPositionCheckpoint2] ||
      [adsPosition isEqualToString:kValueAdsPositionCheckpoint3] ||
      [adsPosition isEqualToString:kValueAdsPositionCheckpoint4])
    [_tblSkills reloadData];
}

- (void)getInAppMessages {
  [[MMServerHelper railsApiHelper] getInAppMessage:^(NSArray *messageIds, NSString *messageHtml, NSError *error) {
    if (error != nil || messageHtml == nil)
      return;
    
    MMVoucherPagePopup *popup = [[MMVoucherPagePopup alloc] initWithHtml:messageHtml];
    [popup showFromPoint:self.view.center];
    
    [popup setOnClosePressed:^(UAModalPanel* panel) {
      [[MMServerHelper railsApiHelper] markInAppMessagesAsRead:messageIds];
      [panel hide];
    }];
  }];
}

@end
