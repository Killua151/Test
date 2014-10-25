//
//  FTProfileViewController.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMProfileViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate> {
  IBOutlet UITableView *_tblProfileInfo;
  
  IBOutlet UITableViewCell *_celAvatarNameLevel;
  IBOutlet UIImageView *_imgAvatar;
  IBOutlet UIButton *_btnEditAvatar;
  IBOutlet UIButton *_btnInteraction;
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
  
  IBOutlet UILabel *_lblAppVersion;
}

- (id)initWithUserId:(NSString *)userId;

- (IBAction)btnEditAvatarPressed:(UIButton *)sender;
- (IBAction)btnInteractionPressed:(UIButton *)sender;
- (IBAction)btnSwitchCoursePressed:(UIButton *)sender;
- (IBAction)btnSetGoalPressed:(UIButton *)sender;
- (IBAction)btnAddFriendPressed:(UIButton *)sender;

@end
