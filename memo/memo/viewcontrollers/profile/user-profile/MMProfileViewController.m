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
- (void)toggleFriendInteractionButton;
- (void)gotoSettings;
- (void)dismissViewController;
- (void)adjustUsername;
- (void)adjustStreakAndMoneyLabels;
- (void)addGraphChart;
- (void)showEmailInviteDialog;

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
    [self customTitleWithText:MMLocalizedString(@"Profile") color:[UIColor blackColor]];
    
    [self customBarButtonWithImage:nil
                             title:MMLocalizedString(@"Settings")
                             color:UIColorFromRGB(129, 12, 21)
                            target:self
                            action:@selector(gotoSettings)
                          distance:10];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(reloadContents) name:kNotificationReloadProfile object:nil];
  }
  
  [self customBarButtonWithImage:nil
                           title:MMLocalizedString(@"Close")
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
  
  [[MMServerHelper sharedHelper] getProfileDetails:_userId completion:^(MUser *user, NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    
    _userData = user;
    [self updateViews];
  }];
}

- (IBAction)btnEditAvatarPressed:(UIButton *)sender {
}

- (IBAction)btnInteractionPressed:(UIButton *)sender {
  [self toggleFriendInteractionButton];
  
  ShowHudForCurrentView();
  [[MMServerHelper sharedHelper] interactFriend:_userId toFollow:sender.selected completion:^(NSError *error) {
    HideHudForCurrentView();
    
    if (error != nil)
      [self toggleFriendInteractionButton];
    
    ShowAlertWithError(error);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadProfile object:nil];
  }];
}

- (IBAction)btnSwitchCoursePressed:(UIButton *)sender {
}

- (IBAction)btnSetGoalPressed:(UIButton *)sender {
  [self presentViewController:[MMSetGoalViewController navigationController] animated:YES completion:NULL];
}

- (IBAction)btnAddFriendPressed:(UIButton *)sender {
  UIActionSheet *actionSheet =
  [[UIActionSheet alloc]
   initWithTitle:nil
   delegate:self
   cancelButtonTitle:MMLocalizedString(@"Cancel")
   destructiveButtonTitle:nil
   otherButtonTitles:
   MMLocalizedString(@"Find friends"),
   MMLocalizedString(@"Invite by email"),
   MMLocalizedString(@"Find Facebook friends"),
   nil];
  
  [actionSheet showInView:[self mainView]];
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
  BOOL isFriend = ![_userId isEqualToString:[MUser currentUser]._id];
  
  if (indexPath.section == 0) {
    if (indexPath.row == 0)
      return _celAvatarNameLevel.frame.size.height;

    _celStreakMoney.hidden = isFriend;
    return isFriend ? 0 : _celStreakMoney.frame.size.height;
  }
  
  if (indexPath.section == 1) {
    CGFloat delta = _btnSetGoal.hidden ? 20 : 0;
    return _celGraphChart.frame.size.height - delta;
  }
  
  if ([_userData.followings_leaderboard_all_time count] == 0)
    return _celEmptyLeaderboards.frame.size.height;
  
  return [MMProfileLeaderboardCell heightToFitWithData:_userData.followings_leaderboard_all_time[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section < 2 || [_userData.followings_leaderboard_all_time count] == 0)
    return;
  
  MLeaderboardData *following = _userData.followings_leaderboard_all_time[indexPath.row];
  MMProfileViewController *friendProfileVC = [[MMProfileViewController alloc] initWithUserId:following.user_id];
  [[self mainViewController] presentViewController:[friendProfileVC parentNavigationController] animated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 2)
    return;
  
  if (buttonIndex == 0) {
    [self presentViewController:[MMFindFriendsViewController new] animated:YES completion:NULL];
    return;
  }
  
  if (buttonIndex == 1) {
    [self showEmailInviteDialog];
    return;
  }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
  for (UIButton *subview in actionSheet.subviews) {
    if (![subview isKindOfClass:[UIButton class]])
      continue;
    
    NSString *fontSuffix = subview.tag == 4 ? @"-Bold" : @"";
    UIFont *font = [UIFont fontWithName:[NSString stringWithFormat:@"ClearSans%@", fontSuffix] size:17];
    [subview.titleLabel setFont:font];
    subview.titleLabel.textColor = UIColorFromRGB(51, 51, 51);
  }
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    return;
  
  UITextField *emailField = [alertView textFieldAtIndex:0];
  
  if (![emailField.text validateEmail]) {
    [self showEmailInviteDialog];
    return;
  }
  
  ShowHudForCurrentView();
  
  [[MMServerHelper sharedHelper] inviteFriendByEmail:emailField.text completion:^(NSString *message, NSError *error) {
    HideHudForCurrentView();
    ShowAlertWithError(error);
    [UIAlertView showWithTitle:nil andMessage:message];
  }];
}

#pragma mark - Private methods
- (void)setupViews {
  _imgAvatar.superview.layer.cornerRadius = _imgAvatar.frame.size.width/2;
  
#if kTempDisableForCloseBeta
  _btnEditAvatar.hidden = YES;
#endif
  
  _lblUsername.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  
  _btnInteraction.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:13];
  _btnInteraction.layer.cornerRadius = 4;
  
  _btnStreak.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
  _btnStreak.titleLabel.adjustsFontSizeToFitWidth = YES;
  _btnStreak.titleLabel.minimumScaleFactor = 13.0/_btnStreak.titleLabel.font.pointSize;
  _btnMoney.titleLabel.adjustsFontSizeToFitWidth = YES;
  _btnMoney.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
  _btnMoney.titleLabel.minimumScaleFactor = 13.0/_btnMoney.titleLabel.font.pointSize;
  
  _lblCourseName.font = [UIFont fontWithName:@"ClearSans" size:18];
  
  _btnSwitchCourse.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnSwitchCourse setTitle:MMLocalizedString(@"Change language") forState:UIControlStateNormal];
  
#if kTempDisableForCloseBeta
  _btnSwitchCourse.hidden = YES;
#endif
  
  _btnSetGoal.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnSetGoal setTitle:MMLocalizedString(@"Set goal") forState:UIControlStateNormal];
  
  _lblLeaderboardsHeader.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblLeaderboardsHeader.text = MMLocalizedString(@"Leaderboards");
  
  _btnAddFriend.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_btnAddFriend setTitle:MMLocalizedString(@"Add friends") forState:UIControlStateNormal];
  
  _lblEmptyLeaderboards.font = [UIFont fontWithName:@"ClearSans" size:13];
  _lblEmptyLeaderboards.text = MMLocalizedString(@"No leaderboards data");
}

- (void)updateViews {
  BOOL isFriend = ![_userId isEqualToString:[MUser currentUser]._id];
  
  _lblUsername.hidden = _btnSetGoal.hidden = _btnAddFriend.hidden = isFriend;
  _btnInteraction.hidden = !isFriend;
  
#if kTempDisableForCloseBeta
  _btnSetGoal.hidden = YES;
#endif
  
  if (isFriend) {
    [self customTitleWithText:_userData.username color:[UIColor blackColor]];
    BOOL isFollowing = [[MUser currentUser].following_user_ids containsObject:_userId];
    _btnInteraction.selected = !isFollowing;
    [self toggleFriendInteractionButton];
  } else
    _lblUsername.text = _userData.username;
  
  _lblLevel.text = [NSString stringWithFormat:@"%ld", (long)_userData.level];
  _lblCourseName.text = _userData.current_course_name;
  
  [_btnStreak setTitle:[NSString stringWithFormat:MMLocalizedString(@"%d Combo days"), (long)_userData.combo_days]
              forState:UIControlStateNormal];
  [_btnMoney setTitle:[NSString stringWithFormat:MMLocalizedString(@"%d MemoCoin"), (long)_userData.virtual_money]
             forState:UIControlStateNormal];
  
  [self addGraphChart];
  [_tblProfileInfo reloadData];
}

- (void)toggleFriendInteractionButton {
  _btnInteraction.selected = !_btnInteraction.selected;
  NSString *title = _btnInteraction.selected ? @"UNFOLLOW" : @"FOLLOW";
  [_btnInteraction setTitle:MMLocalizedString(title) forState:UIControlStateNormal];
  [Utils adjustButtonToFitWidth:_btnInteraction padding:16 constrainsToWidth:110];
  _btnInteraction.center = _lblUsername.center;
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
  return;
  
  CGRect frame = _btnStreak.frame;
  frame.origin = CGPointMake(15, 22);
  _btnStreak.frame = frame;
  
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

- (void)showEmailInviteDialog {
  UIAlertView *alertView = [[UIAlertView alloc]
                            initWithTitle:MMLocalizedString(@"Invite by email")
                            message:MMLocalizedString(@"Enter your friend's email to send them invite")
                            delegate:self
                            cancelButtonTitle:MMLocalizedString(@"Cancel")
                            otherButtonTitles:MMLocalizedString(@"Invite"), nil];
  
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  
  UITextField *emailField = [alertView textFieldAtIndex:0];
  emailField.keyboardType = UIKeyboardTypeEmailAddress;
  emailField.placeholder = MMLocalizedString(@"Email");
  
  [alertView show];
}

@end
