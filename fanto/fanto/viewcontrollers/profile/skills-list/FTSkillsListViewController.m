//
//  FTSkillsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillsListViewController.h"
#import "FTHexagonSkillCell.h"
#import "MSkill.h"

@interface FTSkillsListViewController () {
  NSArray *_skillsData;
}

- (void)gotoProfile;
- (void)gotoShop;

@end

@implementation FTSkillsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:@"Tiếng Anh" color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"Thông tin" target:self action:@selector(gotoProfile) distance:8];
  [self customBarButtonWithImage:nil title:@"Cửa hàng" target:self action:@selector(gotoShop) distance:-8];
  
  _tblSkills.tableFooterView =
  [[UIView alloc] initWithFrame:(CGRect){CGPointZero, (CGSize){_tblSkills.frame.size.width, 50}}];
  
  _skillsData = @[
  @[[MSkill new]],
  @[[MSkill new], [MSkill new]],
  @[[MSkill new], [MSkill new], [NSNull null]],
  @[[MSkill new], [MSkill new]],
  @[[NSNull null], [MSkill new], [MSkill new]],
  @[[MSkill new], [MSkill new]],
  @[[MSkill new]],
  @[[MSkill new], [MSkill new]],
  @[[MSkill new], [MSkill new], [NSNull null]],
  @[[MSkill new], [MSkill new]],
  @[[NSNull null], [MSkill new], [MSkill new]],
  @[[MSkill new], [MSkill new]],
  @[[MSkill new]],
  @[[MSkill new], [MSkill new]],
  @[[MSkill new], [MSkill new], [NSNull null]],
  @[[MSkill new], [MSkill new]],
  @[[NSNull null], [MSkill new], [MSkill new]],
  @[[MSkill new], [MSkill new]]
  ];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_skillsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *skills = _skillsData[indexPath.row];
  
  NSString *reuseIdentifier = [FTHexagonSkillCell reuseIdentifierForSkills:skills];
  
  FTHexagonSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  
  if (cell == nil) {
    DLog(@"invoke %d %@", indexPath.row, reuseIdentifier);
    cell = [[FTHexagonSkillCell alloc] initWithReuseIdentifier:reuseIdentifier];
  }
  
  [cell updateCellWithSkills:skills];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [FTHexagonSkillCell heightToFitWithData:nil];
}

#pragma mark - Private methods
- (void)gotoProfile {
}

- (void)gotoShop {
}

@end
