//
//  FTShieldLessonsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShieldLessonsListViewController.h"
#import "FTShieldLessonCell.h"

@interface FTShieldLessonsListViewController ()

- (void)setupViews;

@end

@implementation FTShieldLessonsListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  [super reloadContents];
}

- (UIColor *)navigationTextColor {
  return [UIColor blackColor];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FTShieldLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FTShieldLessonCell class])];
  
  if (cell == nil) {
    cell = [FTShieldLessonCell new];
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
  }
  
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
}

@end
