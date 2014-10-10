//
//  MMFindFriendsViewController.h
//  memo
//
//  Created by Ethan Nguyen on 10/10/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "BaseViewController.h"

@interface MMFindFriendsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MMFindFriendDelegate> {
  IBOutlet UITableView *_tblFriends;
  IBOutlet UITableViewCell *_celEmpty;
  IBOutlet UILabel *_lblEmpty;
  IBOutlet UITextField *_txtSearchFriends;
  IBOutlet UIButton *_btnClose;
}

- (IBAction)btnClosePressed:(UIButton *)sender;

@end
