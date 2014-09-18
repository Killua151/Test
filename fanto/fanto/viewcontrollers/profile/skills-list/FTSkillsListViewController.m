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
#import "MSkill.h"

@interface FTSkillsListViewController () {
  NSArray *_skillsData;
  FTLessonsListViewController *_lessonsListVC;
  FTShopViewController *_shopVC;
  UIButton *_currentStrengthenButton;
}

- (void)gotoProfile;
- (void)gotoShop;
- (void)setupViews;
- (void)animateSlideStrengthenButton:(BOOL)show;

@end

@implementation FTSkillsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customTitleWithText:@"Tiếng Anh" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Profile", nil)
                           color:[UIColor blackColor]
                          target:self
                          action:@selector(gotoProfile)
                        distance:8];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Shop", nil)
                           color:[UIColor blackColor]
                          target:self
                          action:@selector(gotoShop)
                        distance:-8];
  
  [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _lessonsListVC = nil;
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
    
    return cell;
  }
  
  NSString *reuseIdentifier = [FTSkillCell reuseIdentifierForSkills:skills];
  
  FTSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  
  if (cell == nil) {
    cell = [[[FTSkillCell currentSkillCellClass] alloc] initWithReuseIdentifier:reuseIdentifier];
    cell.delegate = self;
  }
  
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
  
  DLog(@"%@", indexPath);
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

#pragma mark - Private methods
- (void)gotoProfile {
  [self.navigationController presentViewController:[FTProfileViewController navigationController]
                                          animated:YES
                                        completion:NULL];
}

- (void)gotoShop {
  if (_shopVC == nil)
    _shopVC = [FTShopViewController new];
  
  [self.navigationController pushViewController:_shopVC animated:YES];
  [_shopVC reloadContents];
}

- (void)setupViews {
  _btnHexagonStrengthen.hidden = _btnShieldStrengthen.hidden = YES;
  _currentStrengthenButton = kHexagonThemeTestMode ? _btnHexagonStrengthen : _btnShieldStrengthen;
  _currentStrengthenButton.hidden = NO;
  
  CGFloat footerViewDelta = kHexagonThemeTestMode ? 52 : 22;
  _tblSkills.tableFooterView =
  [[UIView alloc] initWithFrame:
   (CGRect){CGPointZero, (CGSize){_tblSkills.frame.size.width, _vStrengthenButton.frame.size.height + footerViewDelta}}];
  
  _skillsData = @[
                  @[[MSkill new]],
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
}

- (void)animateSlideStrengthenButton:(BOOL)show {
  if (show) {
    [UIView
     animateWithDuration:0.5
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
   animateWithDuration:0.5
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

@end
