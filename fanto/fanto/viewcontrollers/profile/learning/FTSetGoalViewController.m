//
//  FTSetGoalViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSetGoalViewController.h"

@interface FTSetGoalViewController ()

- (void)setupViews;

@end

@implementation FTSetGoalViewController

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
  _lblMessage.text = NSLocalizedString(@"Let's get started!", nil);
  [Utils adjustLabelToFitHeight:_lblMessage];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblSubMessage.text = NSLocalizedString(@"If you’re serious about learning a language, you should set a goal to keep you on track.", nil);
  [Utils adjustLabelToFitHeight:_lblSubMessage];
  
  _btnSetGoal.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSetGoal.layer.cornerRadius = 4;
  [_btnSetGoal setTitle:NSLocalizedString(@"Set daily goal", nil) forState:UIControlStateNormal];
  
  _btnSkip.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSkip.layer.cornerRadius = 4;
  _btnSkip.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnSkip.layer.borderWidth = 2;
  [_btnSkip setTitle:NSLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
}

@end
