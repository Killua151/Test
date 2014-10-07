//
//  FTEndLearningViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMEndLearningViewController.h"

@interface MMEndLearningViewController ()

@end

@implementation MMEndLearningViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  // Implement in child class
}

@end
