//
//  FTSkillsListViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTSkillsListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, FTSkillViewDelegate> {
  IBOutlet UITableView *_tblSkills;
  IBOutlet UIButton *_btnStrengthen;
}

- (IBAction)btnStrengthenPressed:(UIButton *)sender;


@end