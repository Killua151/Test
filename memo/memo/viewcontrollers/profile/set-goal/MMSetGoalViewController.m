//
//  FTSetGoalViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSetGoalViewController.h"
#import "MMSetGoalCell.h"

@interface MMSetGoalViewController () {
  NSArray *_goalsData;
}

- (void)setupViews;

@end

@implementation MMSetGoalViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(238, 238, 238)];
  [self customTitleWithText:MMLocalizedString(@"Set goal") color:[UIColor blackColor]];
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  [self customBarButtonWithImage:nil
                           title:MMLocalizedString(@"Close")
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(dismissViewController)
                        distance:-8];
  
  _goalsData = @[
                 @{@"title" : MMLocalizedString(@"Easy"), @"value" : @10},
                 @{@"title" : MMLocalizedString(@"Medium"), @"value" : @20},
                 @{@"title" : MMLocalizedString(@"Hard"), @"value" : @30},
                 @{@"title" : MMLocalizedString(@"Very hard"), @"value" : @50},
                 @{@"title" : MMLocalizedString(@"Turn off Coach mode"), @"value" : @0}
                 ];
  [_tblGoals selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]
                         animated:YES
                   scrollPosition:UITableViewScrollPositionNone];
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)btnAcceptPressed:(UIButton *)sender {
  [self dismissViewController];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_goalsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MMSetGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MMSetGoalCell class])];
  
  if (cell == nil)
    cell = [MMSetGoalCell new];
  
  [cell updateCellWithData:_goalsData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [MMSetGoalCell heightToFitWithData:_goalsData[indexPath.row]];
}

#pragma mark - Private methods
- (void)setupViews {
  _btnAccept.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnAccept.layer.cornerRadius = 4;
  [_btnAccept setTitle:MMLocalizedString(@"Accept") forState:UIControlStateNormal];
}

@end
