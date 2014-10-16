//
//  FTFailLessonViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMFailLessonViewController.h"
#import "MMSkillsListViewController.h"
#import "MMAppDelegate.h"

@interface MMFailLessonViewController ()

@end

@implementation MMFailLessonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  _lblMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblMessage.text = MMLocalizedString(@"You have no healths remained!");
  
  _btnRetry.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnRetry.layer.cornerRadius = 4;
  [_btnRetry setTitle:MMLocalizedString(@"Retry") forState:UIControlStateNormal];
  
  _btnQuit.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnQuit.layer.cornerRadius = 4;
  _btnQuit.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnQuit.layer.borderWidth = 3;
  [_btnQuit setTitle:MMLocalizedString(@"Quit") forState:UIControlStateNormal];
}

- (IBAction)btnRetryPressed:(UIButton *)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    if ([_delegate respondsToSelector:@selector(userDidRetryLesson)])
      [_delegate userDidRetryLesson];
  }];
}

- (IBAction)btnQuitPressed:(UIButton *)sender {
  [self transitToViewController:[MMSkillsListViewController navigationController]];
}

@end
