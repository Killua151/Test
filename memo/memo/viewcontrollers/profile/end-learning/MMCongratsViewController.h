//
//  FTCongratsViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMEndLearningViewController.h"

@interface MMCongratsViewController : MMEndLearningViewController <MMActionSheetDelegate, UAModalPanelDelegate> {
  IBOutlet UIImageView *_imgAnt;
  IBOutlet UIView *_vLevelUp;
  IBOutlet UILabel *_lblLevel;
  IBOutlet UILabel *_lblMessage;
  IBOutlet UILabel *_lblSubMessage;
  IBOutlet UIButton *_btnGetVoucher;
  IBOutlet UIButton *_btnShare;
  IBOutlet UIButton *_btnNext;
}

@property (nonatomic, strong) NSDictionary *displayingData;

- (IBAction)btnGetVoucherPressed:(UIButton *)sender;
- (IBAction)btnSharePressed:(UIButton *)sender;
- (IBAction)btnNextPressed:(UIButton *)sender;

@end
