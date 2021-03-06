//
//  FTLessonsListViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMLessonsListViewController.h"
#import "MMHexagonLessonsListViewController.h"
#import "MMShieldLessonsListViewController.h"
#import "MMExamViewController.h"
#import "MSkill.h"

@interface MMLessonsListViewController ()

- (void)shortcutTest;

@end

@implementation MMLessonsListViewController

+ (Class)currentLessonsListClass {
#if kHexagonThemeDisplayMode
  return [MMHexagonLessonsListViewController class];
#else
  return [MMShieldLessonsListViewController class];
#endif
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self reloadContents];
  
  [Utils logAnalyticsForEvent:kValueTrackingsEventLessonsList];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customTitleWithText:_skillData.title color:[self navigationTextColor]];
  
  if (_skillData.unlocked && ![_skillData isFinished] && _skillData.allow_shortcut)
    [self customBarButtonWithImage:nil
                             title:MMLocalizedString(@"Shortcut")
                             color:[self navigationTextColor]
                            target:self
                            action:@selector(shortcutTest)
                          distance:-8];
  else
    [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:-8];
}

- (UIColor *)navigationTextColor {
  // Implement in child class
  return nil;
}

- (void)reloadContents {
}

#pragma mark - Private methods
- (void)shortcutTest {
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper]
   startShortcutTest:_skillData._id
   completion:^(NSString *examToken,
                NSInteger maxHeartsCount,
                NSDictionary *availableItems,
                NSArray *questions,
                NSError *error) {
     HideHudForCurrentView();
     ShowAlertWithError(error);
     
     MMExamViewController *examVC =
     [[MMExamViewController alloc] initWithQuestions:questions
                                      maxHeartsCount:maxHeartsCount
                                      availableItems:availableItems
                                         andMetadata:@{
                                                       kParamType : kValueExamTypeShortcut,
                                                       kParamExamToken : [NSString normalizedString:examToken],
                                                       kParamSkillId : _skillData._id
                                                       }];
     
     [self presentViewController:examVC animated:YES completion:NULL];
   }];
}

@end
