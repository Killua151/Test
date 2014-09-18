//
//  FTProfileViewController.m
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTProfileViewController.h"
#import "FTSettingsViewController.h"

@interface FTProfileViewController () {
  FTSettingsViewController *_settingsVC;
}

- (void)setupViews;
- (void)gotoSettings;
- (void)dismissViewController;
- (void)adjustUsernameAndLevelLabels;
- (void)adjustStreakAndMoneyLabels;

@end

@implementation FTProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:NSLocalizedString(@"Profile", nil) color:[UIColor blackColor]];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Settings", nil)
                           color:[UIColor blackColor]
                          target:self
                          action:@selector(gotoSettings)
                        distance:8];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Close", nil)
                           color:[UIColor blackColor]
                          target:self
                          action:@selector(dismissViewController)
                        distance:-8];
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  _settingsVC = nil;
}

- (void)reloadContents {
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    [self adjustUsernameAndLevelLabels];
    return _celAvatarNameLevel;
  }
  
  if (indexPath.row == 1) {
    [self adjustStreakAndMoneyLabels];
    return _celStreakMoney;
  }
  
  return nil;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return _celAvatarNameLevel.frame.size.height;
  
  if (indexPath.row == 1)
    return _celStreakMoney.frame.size.height;
  
  return 0;
}

#pragma mark - Private methods
- (void)setupViews {
  _imgAvatar.superview.layer.cornerRadius = _imgAvatar.frame.size.width/2;
  _btnStreak.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
  _btnMoney.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:18];
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

- (void)adjustUsernameAndLevelLabels {
  CGSize sizeThatFits = [_lblUsername sizeThatFits:CGSizeMake(_celAvatarNameLevel.frame.size.width * 0.5,
                                                              _lblUsername.frame.size.height)];
  CGRect frame = _lblUsername.frame;
  frame.size.width = sizeThatFits.width;
  frame.origin.x = (_celAvatarNameLevel.frame.size.width - frame.size.width)/2;
  _lblUsername.frame = frame;
  
  frame = _lblLevel.superview.frame;
  frame.origin.x = _lblUsername.frame.origin.x + _lblUsername.frame.size.width + 5;
  _lblLevel.superview.frame = frame;
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

@end
