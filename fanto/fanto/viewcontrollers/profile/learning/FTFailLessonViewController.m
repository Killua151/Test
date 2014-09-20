//
//  FTFailLessonViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTFailLessonViewController.h"
#import "FTFinishSkillViewController.h"

@interface FTFailLessonViewController ()

- (void)setupViews;

@end

@implementation FTFailLessonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)btnRetryPressed:(UIButton *)sender {
  [self.navigationController pushViewController:[FTFinishSkillViewController new] animated:YES];
}

- (IBAction)btnQuitPressed:(UIButton *)sender {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Private methods
- (void)setupViews {
  _lblMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblMessage.text = NSLocalizedString(@"Bạn đã dùng hết trái tim!", nil);
  
  _btnRetry.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnRetry.layer.cornerRadius = 4;
  [_btnRetry setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
  
  _btnQuit.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnQuit.layer.cornerRadius = 4;
  _btnQuit.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnQuit.layer.borderWidth = 3;
  [_btnQuit setTitle:NSLocalizedString(@"Quit", nil) forState:UIControlStateNormal];
}

@end
