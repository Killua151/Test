//
//  FTCoursesListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMCoursesListViewController.h"
#import "MMSkillsListViewController.h"
#import "MMCourseSelectionCell.h"
#import "MCourse.h"
#import "MUser.h"

@interface MMCoursesListViewController () {
  NSMutableArray *_coursesData;
}

- (void)setupViews;

@end

@implementation MMCoursesListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if ([self.navigationController.viewControllers count] > 1)
    [self customBackButtonWithSuffix:nil];
  
  [self customTitleWithText:MMLocalizedString(@"Select language") color:UIColorFromRGB(51, 51, 51)];
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)beforeGoBack {
  if ([_delegate respondsToSelector:@selector(coursesListDidGoBack)])
    [_delegate coursesListDidGoBack];
}

- (void)reloadContents {
  if (_coursesData == nil)
    _coursesData = [NSMutableArray new];
  
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper] getCourses:^(NSArray *courses, NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    [_coursesData removeAllObjects];
    [_coursesData addObjectsFromArray:courses];
    [_tblCourses reloadData];
  }];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_coursesData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MMCourseSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 NSStringFromClass([MMCourseSelectionCell class])];
  
  if (cell == nil)
    cell = [MMCourseSelectionCell new];
  
  [cell updateCellWithData:_coursesData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [MMCourseSelectionCell heightToFitWithData:_coursesData[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MCourse *course = _coursesData[indexPath.row];
  
  if (!course.enabled)
    return;
  
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper] selectCourse:course._id completion:^(NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    [self
     transitToViewController:[MMSkillsListViewController navigationController]
     completion:^(UIViewController *viewController) {
       MMSkillsListViewController *skillsListVC = ((UINavigationController *)viewController).viewControllers[0];
       [skillsListVC loadSkillsTree];
     }];
  }];
}

#pragma mark - Private methods
- (void)setupViews {
  if (![self.navigationController.view.backgroundColor isEqual:[UIColor clearColor]]) {
    _tblCourses.frame = (CGRect){
      CGPointMake(0, 20),
      CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-20)
    };
    return;
  }
  
  _tblCourses.tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(320, 15)}];
  
  if (!DeviceSystemIsOS7())
    _tblCourses.frame = (CGRect){
      CGPointMake(0, 44),
      CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-44)
    };
  else
    _tblCourses.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
}

@end
