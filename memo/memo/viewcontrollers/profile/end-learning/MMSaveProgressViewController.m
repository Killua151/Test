//
//  FTSaveProgressViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSaveProgressViewController.h"

@interface MMSaveProgressViewController ()

@end

@implementation MMSaveProgressViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _lblMessage.frame;
    frame.origin.y = DeviceSystemIsOS7() ? 30 : 20;
    _lblMessage.frame = frame;
    
    frame = _imgAnt.frame;
    frame.origin.y = _lblMessage.frame.origin.y + _lblMessage.frame.size.height + (DeviceSystemIsOS7() ? 15 : 10);
    _imgAnt.frame = frame;
    
    frame = _lblSubMessage.frame;
    frame.origin.y = _imgAnt.frame.origin.y + _imgAnt.frame.size.height +
    (DeviceSystemIsOS7() ? 15 : 10);
    _lblSubMessage.frame = frame;
  }
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblMessage.text = NSLocalizedString(@"Save your progress", nil);
  [Utils adjustLabelToFitHeight:_lblMessage];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblSubMessage.text = NSLocalizedString(@"You now need a Memo profile to save your progress. Register now!", nil);
  [Utils adjustLabelToFitHeight:_lblSubMessage];
  
  _btnCreateProfile.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnCreateProfile.layer.cornerRadius = 4;
  [_btnCreateProfile setTitle:NSLocalizedString(@"Create profile", nil) forState:UIControlStateNormal];
  
  _btnCancel.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnCancel.layer.cornerRadius = 4;
  _btnCancel.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnCancel.layer.borderWidth = 2;
  [_btnCancel setTitle:NSLocalizedString(@"Cancel my progress", nil) forState:UIControlStateNormal];
}

- (IBAction)btnCreateProfile:(UIButton *)sender {
}

- (IBAction)btnCancel:(UIButton *)sender {
}

@end
