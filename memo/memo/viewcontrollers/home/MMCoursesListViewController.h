//
//  FTCoursesListViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMCoursesListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UITableView *_tblCourses;
}

@property (nonatomic, assign) id<MMCoursesListDelegate> delegate;

@end
