//
//  FTShieldLessonsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMShieldLessonsListViewController.h"
#import "MMShieldLessonCell.h"
#import "MLesson.h"

@interface MMShieldLessonsListViewController () {
  NSArray *_lessonsData;
}

- (void)setupViews;

@end

@implementation MMShieldLessonsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  [super reloadContents];
  
  if (self.skillData == nil)
    return;
  
  _lessonsData = @[[MLesson new], [MLesson new], [MLesson new], [MLesson new], [MLesson new]];
  [_tblLessons reloadData];
}

- (UIColor *)navigationTextColor {
  return [UIColor blackColor];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MMShieldLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MMShieldLessonCell class])];
  
  if (cell == nil) {
    cell = [MMShieldLessonCell new];
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
  }
  
  [cell updateCellWithData:_lessonsData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark - Private methods
- (void)setupViews {
  _tblLessons.transform = CGAffineTransformMakeRotation(-M_PI_2);
  CGRect frame = _tblLessons.frame;
  frame.size.width = self.view.frame.size.width;
  frame.size.height = [UIScreen mainScreen].bounds.size.height - kHeightStatusBar - kHeightNavigationBar;
  frame.origin = CGPointZero;
  _tblLessons.frame = frame;
  
  _vLessonsBg.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                   ([UIScreen mainScreen].bounds.size.height - kHeightNavigationBar - kHeightStatusBar)/2);
  frame = _vSkillStatus.frame;
  frame.origin.y = _vLessonsBg.frame.origin.y - 44;
  _vSkillStatus.frame = frame;
  
  [_tblLessons reloadData];
}

@end
