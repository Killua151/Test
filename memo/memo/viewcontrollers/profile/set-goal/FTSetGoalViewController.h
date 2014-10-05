//
//  FTSetGoalViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTSetGoalViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *_tblGoals;
  IBOutlet UIButton *_btnAccept;
}

- (IBAction)btnAcceptPressed:(UIButton *)sender;

@end
