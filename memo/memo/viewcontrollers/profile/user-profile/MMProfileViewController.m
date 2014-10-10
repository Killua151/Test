//
//  FTProfileViewController.m
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMProfileViewController.h"
#import "MMSettingsViewController.h"
#import "MMProfileLeaderboardCell.h"
#import "MMSetGoalViewController.h"
#import "MMFindFriendsViewController.h"
#import "MUser.h"
#import "MLeaderboardData.h"

@interface MMProfileViewController () {
  MMSettingsViewController *_settingsVC;
  MMLineChart *_lineChart;
  NSString *_userId;
  MUser *_userData;
}

- (void)setupViews;
- (void)updateViews;
- (void)gotoSettings;
- (void)dismissViewController;
- (void)adjustUsername;
- (void)adjustStreakAndMoneyLabels;
- (void)addGraphChart;

@end

@implementation MMProfileViewController

- (id)initWithUserId:(NSString *)userId {
  if (self = [super init]) {
    _userId = userId;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  
  if (_userId == nil)
    _userId = [MUser currentUser]._id;
  
  if ([_userId isEqualToString:[MUser currentUser]._id]) {
    [self customTitleWithText:NSLocalizedString(@"Profile", nil) color:[UIColor blackColor]];
    
    [self customBarButtonWithImage:nil
                             title:NSLocalizedString(@"Settings", nil)
                             color:UIColorFromRGB(129, 12, 21)
                            target:self
                            action:@selector(gotoSettings)
                          distance:10];
  }
  
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

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)reloadContents {
  ShowHudForCurrentView();
  
  [[MMServerHelper sharedHelper] getProfileDetails:nil completion:^(MUser *user, NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    _userData = user;
    [self updateViews];
  }];
}

- (IBAction)btnSwitchCoursePressed:(UIButton *)sender {
}

- (IBAction)btnSetGoalPressed:(UIButton *)sender {
  [self presentViewController:[MMSetGoalViewController navigationController] animated:YES completion:NULL];
}

- (IBAction)btnAddFriendPressed:(UIButton *)sender {
  [self presentViewController:[MMFindFriendsViewController new] animated:YES completion:NULL];
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
  
  if ([_userData.followings_leaderboard_all_time count] == 0)
    return 1;
  
  return [_userData.followings_leaderboard_all_time count];
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
  
  if ([_userData.followings_leaderboard_all_time count] == 0)
    return _celEmptyLeaderboards;
  
  MMProfileLeaderboardCell *cell = [_tblProfileInfo dequeueReusableCellWithIdentifier:
                                    NSStringFromClass([MMProfileLeaderboardCell class])];
  
  if (cell == nil)
    cell = [MMProfileLeaderboardCell new];
  
  [cell updateCellWithData:_userData.followings_leaderboard_all_time[indexPath.row]];
  
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
  
  if ([_userData.followings_leaderboard_all_time count] == 0)
    return _celEmptyLeaderboards.frame.size.height;
  
  return [MMProfileLeaderboardCell heightToFitWithData:_userData.followings_leaderboard_all_time[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MLeaderboardData *following = _userData.followings_leaderboard_all_time[indexPath.row];
  MMProfileViewController *friendProfileVC = [[MMProfileViewController alloc] initWithUserId:following.user_id];
  UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:friendProfileVC];
  [[self mainViewController] presentViewController:navigation animated:YES completion:NULL];
}

#pragma mark - Private methods
- (void)setupViews {
  _imgAvatar.superview.layer.cornerRadius = _imgAvatar.frame.size.width/2;
  _lblUsername.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  
  _btnStreak.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
  _btnMoney.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
  
  _lblCourseName.font = [UIFont fontWithName:@"ClearSans" size:18];
  _lblCourseName.text = NSLocalizedString(_userData.current_course, nil);
  
  _btnSwitchCourse.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnSwitchCourse setTitle:NSLocalizedString(@"Switch course", nil) forState:UIControlStateNormal];
  _btnSwitchCourse.hidden = YES;
  
  _btnSetGoal.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnSetGoal setTitle:NSLocalizedString(@"Set goal", nil) forState:UIControlStateNormal];
  
  _lblLeaderboardsHeader.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblLeaderboardsHeader.text = NSLocalizedString(@"Leaderboards", nil);
  
  _btnAddFriend.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnAddFriend setTitle:NSLocalizedString(@"Add friends", nil) forState:UIControlStateNormal];
  
  _lblEmptyLeaderboards.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblEmptyLeaderboards.text = NSLocalizedString(@"No leaderboards data", nil);
}

- (void)updateViews {
  if ([_userData._id isEqualToString:[MUser currentUser]._id])
    [self customTitleWithText:_userData.username color:[UIColor blackColor]];
  
  _lblUsername.text = _userData.username;
  _lblLevel.text = [NSString stringWithFormat:@"%ld", (long)_userData.level];
  
  [_btnStreak setTitle:[NSString stringWithFormat:@"%ld Combo days", (long)_userData.combo_days]
              forState:UIControlStateNormal];
  [_btnMoney setTitle:[NSString stringWithFormat:@"%ld Memo Coins", (long)_userData.virtual_money]
             forState:UIControlStateNormal];
  
  [self addGraphChart];
  [_tblProfileInfo reloadData];
}

- (void)gotoSettings {
  if (_settingsVC == nil)
    _settingsVC = [MMSettingsViewController new];
  
  _settingsVC.userData = _userData;
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
  
  _lineChart = [_userData graphLineChartInFrame:CGRectMake(0, 41, 320, 215)];
  [_celGraphChart.contentView addSubview:_lineChart];
  [_lineChart drawChart];
}

@end
