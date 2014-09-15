//
//  FTSkillsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillsListViewController.h"
#import "FTHexagonSkillCell.h"
#import "FTHexagonCheckpointTestCell.h"
#import "FTHexagonLessonsListViewController.h"
#import "MSkill.h"

@interface FTSkillsListViewController () {
  NSArray *_skillsData;
  FTHexagonLessonsListViewController *_lessonsListVC;
}

- (void)gotoProfile;
- (void)gotoShop;
- (void)animateSlideStrengthenButton:(BOOL)show;

@end

@implementation FTSkillsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customTitleWithText:@"Tiếng Anh" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"Thông tin" color:[UIColor blackColor] target:self action:@selector(gotoProfile) distance:8];
  [self customBarButtonWithImage:nil title:@"Cửa hàng" color:[UIColor blackColor] target:self action:@selector(gotoShop) distance:-8];
  
  _tblSkills.tableFooterView =
  [[UIView alloc] initWithFrame:
   (CGRect){CGPointZero, (CGSize){_tblSkills.frame.size.width, _btnStrengthen.frame.size.height + 52}}];
  
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
    FTHexagonCheckpointTestCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FTHexagonCheckpointTestCell class])];
    
    if (cell == nil)
      cell = [FTHexagonCheckpointTestCell new];
    
    return cell;
  }
  
  NSString *reuseIdentifier = [FTHexagonSkillCell reuseIdentifierForSkills:skills];
  
  FTHexagonSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  
  if (cell == nil) {
    cell = [[FTHexagonSkillCell alloc] initWithReuseIdentifier:reuseIdentifier];
    cell.delegate = self;
  }
  
  [cell updateCellWithSkills:skills];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  if (![skills isKindOfClass:[NSArray class]])
    return [FTHexagonCheckpointTestCell heightToFitWithData:nil];
  
  return [FTHexagonSkillCell heightToFitWithData:nil];
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
    _lessonsListVC = [FTHexagonLessonsListViewController new];
  
  [self.navigationController pushViewController:_lessonsListVC animated:YES];
}

#pragma mark - Private methods
- (void)gotoProfile {
}

- (void)gotoShop {
}

- (void)animateSlideStrengthenButton:(BOOL)show {
  if (show) {
    [UIView
     animateWithDuration:0.5
     delay:0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
       CGRect frame = _btnStrengthen.frame;
       frame.origin.y = self.view.frame.size.height - _btnStrengthen.frame.size.height - 15;
       _btnStrengthen.frame = frame;
     }
     completion:^(BOOL finished) {
       _btnStrengthen.enabled = YES;
     }];

    return;
  }
  
  _btnStrengthen.enabled = NO;
  
  [UIView
   animateWithDuration:0.5
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGRect frame = _btnStrengthen.frame;
     frame.origin.y = self.view.frame.size.height + 15;
     _btnStrengthen.frame = frame;
   }
   completion:^(BOOL finished) {
   }];
}

@end
