//
//  FTLessonsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLessonsListViewController.h"
#import "FTHexagonLessonsListViewController.h"
#import "FTShieldLessonsListViewController.h"
#import "MSkill.h"

@interface FTLessonsListViewController ()

- (void)testOut;

@end

@implementation FTLessonsListViewController

+ (Class)currentLessonsListClass {
#if kHexagonThemeTestMode
  return [FTHexagonLessonsListViewController class];
#else
  return [FTShieldLessonsListViewController class];
#endif
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self reloadContents];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customTitleWithText:_skillData.title color:[self navigationTextColor]];
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Test Out", nil)
                           color:[self navigationTextColor]
                          target:self
                          action:@selector(testOut)
                        distance:-8];
}

- (UIColor *)navigationTextColor {
  // Implement in child class
  return nil;
}

- (void)reloadContents {
}

#pragma mark - Private methods
- (void)testOut {
}

@end