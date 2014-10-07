//
//  FTSkillsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillsListViewController.h"
#import "FTCheckpointTestCell.h"
#import "FTSkillCell.h"
#import "FTLessonsListViewController.h"
#import "FTShopViewController.h"
#import "FTProfileViewController.h"

#import "FTBeginPlacementTestViewController.h"
#import "MMExamViewController.h"

#import "MUser.h"
#import "MSkill.h"

@interface FTSkillsListViewController () {
  NSArray *_skillsData;
  FTLessonsListViewController *_lessonsListVC;
  UIButton *_currentStrengthenButton;
}

- (void)gotoProfile;
- (void)gotoShop;
- (void)setupViews;
- (void)animateSlideStrengthenButton:(BOOL)show;
- (void)fadeOutBeginningOptions:(void(^)())completion;
- (void)loadSkillsTree;
- (void)handleLoadingError:(NSError *)error;

@end

@implementation FTSkillsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:UIColorFromRGB(238, 238, 238)];
  [self customTitleWithText:@"Tiếng Anh" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Profile", nil)
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(gotoProfile)
                        distance:8];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Shop", nil)
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(gotoShop)
                        distance:-8];
  
  [self setupViews];
  [self loadSkillsTree];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _lessonsListVC = nil;
}

- (void)reloadContents {
  _skillsData = @[
                  @[[NSNull null], [MSkill new], [NSNull null]],
                  @[[MSkill new], [MSkill new]],
                  @[[MSkill new], [MSkill new], [NSNull null]],
                  @[[MSkill new], [MSkill new]],
                  @[[NSNull null], [MSkill new], [MSkill new]],
                  [NSNull null],
                  @[[MSkill new], [MSkill new]],
                  @[[MSkill new], [NSNull null], [NSNull null]],
                  @[[MSkill new], [MSkill new]],
                  @[[MSkill new], [MSkill new], [NSNull null]],
                  @[[MSkill new], [MSkill new]],
                  @[[NSNull null], [MSkill new], [MSkill new]],
                  [NSNull null],
                  @[[MSkill new], [MSkill new]],
                  @[[MSkill new]],
                  @[[MSkill new], [MSkill new]],
                  @[[MSkill new], [MSkill new], [NSNull null]],
                  @[[MSkill new], [MSkill new]],
                  [NSNull null],
                  @[[NSNull null], [MSkill new], [MSkill new]],
                  @[[MSkill new], [MSkill new]]
                  ];
  
  _skillsData = [[MUser currentUser] skillsTree];
  
  [_tblSkills reloadData];
}

- (IBAction)btnBeginnerPressed:(UIButton *)sender {
  [self fadeOutBeginningOptions:NULL];
}

- (IBAction)btnPlacementTestPressed:(UIButton *)sender {
  [self presentViewController:[FTBeginPlacementTestViewController navigationController]
                     animated:YES
                   completion:NULL];
}

- (IBAction)btnStrengthenPressed:(UIButton *)sender {
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_skillsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  if (![skills isKindOfClass:[NSArray class]]) {
    FTCheckpointTestCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  NSStringFromClass([FTCheckpointTestCell currentCheckpointTestCellClass])];
    
    if (cell == nil)
      cell = [[FTCheckpointTestCell currentCheckpointTestCellClass] new];
    
    [cell updateCellWithData:(MBase *)@(indexPath.row)];
    
    return cell;
  }
  
  NSString *reuseIdentifier = [FTSkillCell reuseIdentifierForSkills:skills];
  
  FTSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  
  if (cell == nil)
    cell = [[[FTSkillCell currentSkillCellClass] alloc] initWithReuseIdentifier:reuseIdentifier
                                                                      withTotal:[skills count]
                                                                       inTarget:self];
  
  [cell updateCellWithSkills:skills];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  if (![skills isKindOfClass:[NSArray class]])
    return [[FTCheckpointTestCell currentCheckpointTestCellClass] heightToFitWithData:nil];
  
  return [[FTSkillCell currentSkillCellClass] heightToFitWithData:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  if ([skills isKindOfClass:[NSArray class]])
    return;
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

#pragma mark - FTSkillViewDelegate methods
- (void)skillViewDidSelectSkill:(MSkill *)skill {
  if (_lessonsListVC == nil)
    _lessonsListVC = [[FTLessonsListViewController currentLessonsListClass] new];
  
  _lessonsListVC.skillData = skill;
  [self.navigationController pushViewController:_lessonsListVC animated:YES];
  [_lessonsListVC reloadContents];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    exit(0);
  
  [self loadSkillsTree];
}

#pragma mark - Private methods
- (void)gotoProfile {
  [self presentViewController:[FTProfileViewController navigationController] animated:YES completion:NULL];
}

- (void)gotoShop {
  [self presentViewController:[FTShopViewController navigationController] animated:YES completion:NULL];
}

- (void)setupViews {
  _btnHexagonStrengthen.hidden = _btnShieldStrengthen.hidden = YES;
  
  _currentStrengthenButton = kHexagonThemeTestMode ? _btnHexagonStrengthen : _btnShieldStrengthen;
  _currentStrengthenButton.hidden = NO;
  _currentStrengthenButton.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
  [_currentStrengthenButton setTitle:NSLocalizedString(@"Strengthen skills", nil) forState:UIControlStateNormal];
  
  _lblBeginnerTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblBeginnerTitle.text = NSLocalizedString(@"Are you a beginner?", nil);
  
  _lblBeginnerSubTitle.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblBeginnerSubTitle.text = NSLocalizedString(@"Start here with the Basics", nil);
  
  _lblPlacementTestTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblPlacementTestTitle.text = NSLocalizedString(@"Not a beginner?", nil);
  
  _lblPlacementTestSubTitle.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblPlacementTestSubTitle.text = NSLocalizedString(@"Try this Placement Test", nil);
  
  CGFloat footerViewDelta = kHexagonThemeTestMode ? 52 : 22;
  _tblSkills.tableFooterView =
  [[UIView alloc] initWithFrame:
   (CGRect){CGPointZero, (CGSize){_tblSkills.frame.size.width, _vStrengthenButton.frame.size.height + footerViewDelta}}];
  
  [self animateSlideStrengthenButton:NO];
}

- (void)animateSlideStrengthenButton:(BOOL)show {
  if (show) {
    [UIView
     animateWithDuration:kDefaultAnimationDuration*2
     delay:0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
       CGRect frame = _vStrengthenButton.frame;
       frame.origin.y = self.view.frame.size.height - _vStrengthenButton.frame.size.height - 15;
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
     frame.origin.y = self.view.frame.size.height + 15;
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

- (void)loadSkillsTree {
  [Utils showHUDForView:self.navigationController.view withText:nil];
  
  [[MMServerHelper sharedHelper] getUserProfile:^(NSDictionary *userData, NSError *error) {
    [Utils hideAllHUDsForView:self.navigationController.view];
    
    if (error != nil) {
      [self handleLoadingError:error];
      return;
    }
    
    [self reloadContents];
  }];
}

- (void)handleLoadingError:(NSError *)error {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Error %d", nil),
                                                               [Utils errorCodeFromError:error]]
                                                      message:[Utils errorMessageFromError:error]
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Quit", nil)
                                            otherButtonTitles:NSLocalizedString(@"Retry", nil), nil];
  
  [alertView show];
}

@end
