//
//  FTShieldLessonsListViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMLessonsListViewController.h"

@interface MMShieldLessonsListViewController : MMLessonsListViewController <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *_tblLessons;
  IBOutlet UIView *_vLessonsBg;
  IBOutlet UIView *_vSkillStatus;
}

@end
