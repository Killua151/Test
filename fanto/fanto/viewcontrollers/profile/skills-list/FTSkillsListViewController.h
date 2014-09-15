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
  IBOutlet UIView *_vStrengthenButton;
  IBOutlet UIButton *_btnHexagonStrengthen;
  IBOutlet UIButton *_btnShieldStrengthen;
}

- (IBAction)btnStrengthenPressed:(UIButton *)sender;

@end
