//
//  FTSkillsListViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMSkillsListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MMSkillViewDelegate, UIAlertViewDelegate> {
  IBOutlet UITableView *_tblSkills;
  IBOutlet UIView *_vBeginningOptions;
  IBOutletCollection(UIView) NSArray *_vIconsBg;
  IBOutlet UILabel *_lblBeginnerTitle;
  IBOutlet UILabel *_lblBeginnerSubTitle;
  IBOutlet UILabel *_lblPlacementTestTitle;
  IBOutlet UILabel *_lblPlacementTestSubTitle;
  
  IBOutlet UIView *_vStrengthenButton;
  IBOutlet UIButton *_btnHexagonStrengthen;
  IBOutlet UIButton *_btnShieldStrengthen;
}

- (IBAction)btnBeginnerPressed:(UIButton *)sender;
- (IBAction)btnPlacementTestPressed:(UIButton *)sender;
- (IBAction)btnStrengthenPressed:(UIButton *)sender;

@end
