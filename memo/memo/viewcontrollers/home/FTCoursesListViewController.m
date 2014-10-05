//
//  FTCoursesListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTCoursesListViewController.h"
#import "FTCourseSelectionCell.h"

@interface FTCoursesListViewController () {
  NSArray *_coursesData;
}

- (void)setupViews;

@end

@implementation FTCoursesListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customBackButtonWithSuffix:nil];
  [self customTitleWithText:NSLocalizedString(@"Select course", nil) color:UIColorFromRGB(51, 51, 51)];
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  _coursesData = @[@"Tiếng Anh", @"Tiếng Pháp", @"Tiếng Đức", @"Tiếng Ý", @"Tiếng Nhật", @"Tiếng Trung"];
  [_tblCourses reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_coursesData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FTCourseSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 NSStringFromClass([FTCourseSelectionCell class])];
  
  if (cell == nil)
    cell = [FTCourseSelectionCell new];
  
  [cell updateCellWithData:_coursesData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [FTCourseSelectionCell heightToFitWithData:_coursesData[indexPath.row]];
}

#pragma mark - Private methods
- (void)setupViews {
  _tblCourses.tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(320, 15)}];
  
  if (!DeviceSystemIsOS7())
    _tblCourses.frame = (CGRect){CGPointMake(0, 44), CGSizeMake(320, self.view.frame.size.height-44)};
  else
    _tblCourses.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
}

@end
