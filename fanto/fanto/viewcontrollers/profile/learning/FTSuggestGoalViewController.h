//
//  FTSetGoalViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTEndLearningViewController.h"

@interface FTSuggestGoalViewController : FTEndLearningViewController {
  IBOutlet UILabel *_lblMessage;
  IBOutlet UIImageView *_imgAnt;
  IBOutlet UILabel *_lblSubMessage;
  IBOutlet UIButton *_btnSetGoal;
  IBOutlet UIButton *_btnSkip;
}

@end
