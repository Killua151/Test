//
//  FTFailLessonViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface FTFailLessonViewController : BaseViewController {
  IBOutlet UILabel *_lblMessage;
  IBOutlet UIImageView *_imgAnt;
  IBOutlet UIButton *_btnRetry;
  IBOutlet UIButton *_btnQuit;
}

- (IBAction)btnRetryPressed:(UIButton *)sender;
- (IBAction)btnQuitPressed:(UIButton *)sender;

@end
