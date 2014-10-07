//
//  FTProfileViewController.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMProfileViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *_tblProfileInfo;
  
  IBOutlet UITableViewCell *_celAvatarNameLevel;
  IBOutlet UIImageView *_imgAvatar;
  IBOutlet UILabel *_lblUsername;
  
  IBOutlet UITableViewCell *_celStreakMoney;
  IBOutlet UIButton *_btnStreak;
  IBOutlet UIButton *_btnMoney;
  
  IBOutlet UITableViewCell *_celGraphChart;
  IBOutlet UILabel *_lblLevel;
  IBOutlet UILabel *_lblCourseName;
  IBOutlet UIButton *_btnSwitchCourse;
  IBOutlet UIButton *_btnSetGoal;
  
  IBOutlet UIView *_vLeaderboardsHeader;
  IBOutlet UILabel *_lblLeaderboardsHeader;
  IBOutlet UIButton *_btnAddFriend;
  
  IBOutlet UITableViewCell *_celEmptyLeaderboards;
  IBOutlet UILabel *_lblEmptyLeaderboards;
}

- (IBAction)btnSwitchCoursePressed:(UIButton *)sender;
- (IBAction)btnSetGoalPressed:(UIButton *)sender;
- (IBAction)btnAddFriendPressed:(UIButton *)sender;

@end
