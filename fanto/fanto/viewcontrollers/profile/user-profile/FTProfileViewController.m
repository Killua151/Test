//
//  FTProfileViewController.m
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTProfileViewController.h"
#import "FTSettingsViewController.h"
#import "FTProfileLeaderboardCell.h"
#import "MUser.h"

@interface FTProfileViewController () {
  FTSettingsViewController *_settingsVC;
  FTLineChart *_lineChart;
  NSArray *_leaderboardsData;
}

- (void)setupViews;
- (void)gotoSettings;
- (void)dismissViewController;
- (void)adjustUsername;
- (void)adjustStreakAndMoneyLabels;
- (void)addGraphChart;

@end

@implementation FTProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:NSLocalizedString(@"Profile", nil) color:[UIColor blackColor]];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Settings", nil)
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(gotoSettings)
                        distance:10];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Close", nil)
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(dismissViewController)
                        distance:-10];
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _settingsVC = nil;
}

- (void)reloadContents {
  _leaderboardsData = @[@"Test", @"abc", @"z_lorem_ipsum", @"abc__def__gasd"];
  [self addGraphChart];
}

- (IBAction)btnSwitchCoursePressed:(UIButton *)sender {
}

- (IBAction)btnSetGoalPressed:(UIButton *)sender {
}

- (IBAction)btnAddFriendPressed:(UIButton *)sender {
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)
    return 2;
  
  if (section == 1)
    return 1;
  
  return [_leaderboardsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      [self adjustUsername];
      return _celAvatarNameLevel;
    }
    
    [self adjustStreakAndMoneyLabels];
    return _celStreakMoney;
  }
  
  if (indexPath.section == 1)
    return _celGraphChart;
  
  FTProfileLeaderboardCell *cell = [_tblProfileInfo dequeueReusableCellWithIdentifier:
                                    NSStringFromClass([FTProfileLeaderboardCell class])];
  
  if (cell == nil)
    cell = [FTProfileLeaderboardCell new];
  
  [cell updateCellWithData:_leaderboardsData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0 || section == 1)
    return nil;
  
  return _vLeaderboardsHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0 || section == 1)
    return 0;
  
  return _vLeaderboardsHeader.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0)
      return _celAvatarNameLevel.frame.size.height;

    return _celStreakMoney.frame.size.height;
  }
  
  if (indexPath.section == 1)
    return _celGraphChart.frame.size.height;
  
  return [FTProfileLeaderboardCell heightToFitWithData:_leaderboardsData[indexPath.row]];
}

#pragma mark - Private methods
- (void)setupViews {
  _imgAvatar.superview.layer.cornerRadius = _imgAvatar.frame.size.width/2;
  _lblUsername.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  
  _btnStreak.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
  _btnMoney.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
  
  _lblCourseName.font = [UIFont fontWithName:@"ClearSans" size:18];
  _btnSwitchCourse.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  _btnSetGoal.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  _lblLeaderboardsHeader.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnAddFriend.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
}

- (void)gotoSettings {
  if (_settingsVC == nil)
    _settingsVC = [FTSettingsViewController new];
  
  [self.navigationController pushViewController:_settingsVC animated:YES];
  [_settingsVC reloadContents];
}

- (void)dismissViewController {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)adjustUsername {
  CGSize sizeThatFits = [_lblUsername sizeThatFits:CGSizeMake(_celAvatarNameLevel.frame.size.width * 0.5,
                                                              _lblUsername.frame.size.height)];
  CGRect frame = _lblUsername.frame;
  frame.size.width = sizeThatFits.width;
  frame.origin.x = (_celAvatarNameLevel.frame.size.width - frame.size.width)/2;
  _lblUsername.frame = frame;
}

- (void)adjustStreakAndMoneyLabels {
  [_btnStreak sizeToFit];
  CGRect frame = _btnStreak.frame;
  frame.origin = CGPointMake(15, 22);
  _btnStreak.frame = frame;
  
  [_btnMoney sizeToFit];
  frame = _btnMoney.frame;
  frame.origin = CGPointMake(_celStreakMoney.frame.size.width - 15 - frame.size.width, 22);
  _btnMoney.frame = frame;
}

- (void)addGraphChart {
  if (_lineChart != nil) {
    [_lineChart removeFromSuperview];
    _lineChart = nil;    
  }
  
  _lineChart = [[MUser currentUser] graphLineChartInFrame:CGRectMake(0, 41, 320, 215)];
  [_celGraphChart.contentView addSubview:_lineChart];
  [_lineChart drawChart];
}

@end
