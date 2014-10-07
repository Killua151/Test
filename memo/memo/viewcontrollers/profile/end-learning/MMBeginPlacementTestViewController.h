//
//  FTBeginPlacementTestViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMEndLearningViewController.h"

@interface MMBeginPlacementTestViewController : MMEndLearningViewController {
  IBOutlet UILabel *_lblMessage;
  IBOutlet UIImageView *_imgAnt;
  IBOutlet UILabel *_lblSubMessage;
  IBOutlet UIButton *_btnStart;
  IBOutlet UIButton *_btnBack;
}

- (IBAction)btnStartPressed:(UIButton *)sender;
- (IBAction)btnBackPressed:(UIButton *)sender;

@end
