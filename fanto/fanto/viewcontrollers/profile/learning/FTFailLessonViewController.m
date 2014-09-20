//
//  FTFailLessonViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTFailLessonViewController.h"

@interface FTFailLessonViewController ()

- (void)setupViews;

@end

@implementation FTFailLessonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Private methods
- (void)setupViews {
  _lblMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblMessage.text = NSLocalizedString(@"", nil);
  
  _btnRetry.layer.cornerRadius = 4;
  [_btnRetry setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
  
  _btnQuit.layer.cornerRadius = 4;
  _btnQuit.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnQuit.layer.borderWidth = 3;
  [_btnQuit setTitle:NSLocalizedString(@"Quit", nil) forState:UIControlStateNormal];
}

@end
