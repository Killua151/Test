//
//  FTMoneyBonusViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTEndLearningViewController.h"

@interface FTMoneyBonusViewController : FTEndLearningViewController {
  IBOutlet UILabel *_lblMessage;
  IBOutlet UILabel *_lblSubMessage;
  IBOutlet UIView *_vCountBadge;
  IBOutlet UILabel *_lblCount;
  IBOutlet UIButton *_btnNext;
}

- (IBAction)btnNextPressed:(UIButton *)sender;

@end
