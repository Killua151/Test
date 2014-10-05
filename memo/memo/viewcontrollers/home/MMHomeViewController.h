//
//  FTHomeViewController.h
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMHomeViewController : BaseViewController {
  IBOutlet UIImageView *_imgBg;
  IBOutlet UIButton *_btnLogIn;
  IBOutlet UIButton *_btnNewUser;
}

- (IBAction)btnLoginPressed:(UIButton *)sender;
- (IBAction)btnNewUserPressed:(UIButton *)sender;

@end
