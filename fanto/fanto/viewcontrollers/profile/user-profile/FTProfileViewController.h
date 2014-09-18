//
//  FTProfileViewController.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTProfileViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *_tblProfileInfo;
  IBOutlet UITableViewCell *_celAvatarNameLevel;
  IBOutlet UIImageView *_imgAvatar;
  IBOutlet UILabel *_lblUsername;
  IBOutlet UILabel *_lblLevel;
  IBOutlet UITableViewCell *_celStreakMoney;
  IBOutlet UIButton *_btnStreak;
  IBOutlet UIButton *_btnMoney;
}

@end
