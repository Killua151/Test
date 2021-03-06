//
//  FTSetGoalViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSuggestGoalViewController.h"

@interface MMSuggestGoalViewController ()

- (void)setupViews;

@end

@implementation MMSuggestGoalViewController

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
  _lblMessage.text = MMLocalizedString(@"Let's get started!");
  [_lblMessage adjustToFitHeight];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblSubMessage.text = MMLocalizedString(@"If you’re serious about learning a language, you should set a goal to keep you on track.");
  [_lblSubMessage adjustToFitHeight];
  
  _btnSetGoal.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSetGoal.layer.cornerRadius = 4;
  [_btnSetGoal setTitle:MMLocalizedString(@"Set daily goal") forState:UIControlStateNormal];
  
  _btnSkip.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSkip.layer.cornerRadius = 4;
  _btnSkip.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnSkip.layer.borderWidth = 2;
  [_btnSkip setTitle:MMLocalizedString(@"Skip") forState:UIControlStateNormal];
}

@end
