//
//  MMPlacementTestViewController.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMPlacementTestViewController.h"
#import "MMSkillsListViewController.h"
#import "MMFinishLessonViewController.h"
#import "MMFailLessonViewController.h"
#import "MMQuestionContentView.h"
#import "MBaseQuestion.h"
#import "MUser.h"

@interface MMPlacementTestViewController ()

@end

@implementation MMPlacementTestViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)prepareNextQuestion {
  if (_currentQuestionIndex == 0) {
    [super prepareNextQuestion];
    return;
  }
  
  ShowHudForCurrentView();
  
  [[MMServerHelper defaultHelper]
   submitPlacementTestAnswer:_answersData
   withMetadata:_metadata
   completion:^(NSString *examToken,
                MBaseQuestion *question,
                NSInteger questionNumber,
                NSInteger totalQuestions,
                BOOL isFinished,
                NSError *error) {
     HideHudForCurrentView();
     
     if (error != nil) {
       [UIAlertView
        showWithError:error
        cancelButtonTitle:MMLocalizedString(@"Quit")
        otherButtonTitles:@[MMLocalizedString(@"Retry")]
        callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
          if (buttonIndex == 0)
            [self dismissViewController];
          else
            [self prepareNextQuestion];
        }];
       
       return;
     }
     
     _totalQuestionsCount = totalQuestions;
     
     if (!isFinished) {
       _metadata[kParamExamToken] = examToken;
       [_questionsData addObject:question];
       [Utils preDownloadAudioFromUrls:[MBaseQuestion audioUrlsFromQuestions:@[question]]];
       [super prepareNextQuestion];
       return;
     }
     
     if ([[MUser currentUser] finishExamBonusExp] > 0)
       [self presentViewController:[MMFinishLessonViewController navigationController] animated:YES completion:NULL];
     else
       [self
        transitToViewController:[MMSkillsListViewController navigationController]
        completion:^(UIViewController *viewController) {
          MMSkillsListViewController *skillsListVC = ((UINavigationController *)viewController).viewControllers[0];
          [skillsListVC loadSkillsTree];
        }];
   }];
}

- (void)checkCurrentQuestion {
  [_answersData removeAllObjects];
  [super checkCurrentQuestion];
}

- (void)removeCurrentQuestion {
  _btnCheck.enabled = NO;
  [self switchCheckButtonMode:YES];
  
  if ([_vContentView.subviews count] == 0) {
    [self prepareNextQuestion];
    return;
  }
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vQuestionContent.alpha = 0;
     CGRect frame = _vQuestionContent.frame;
     frame.origin.x -= 320;
     _vQuestionContent.frame = frame;
   }
   completion:^(BOOL finished) {
     [_vQuestionContent removeFromSuperview];
     _vQuestionContent = nil;
     [self prepareNextQuestion];
   }];
}

- (void)updateHeaderViews {
  _lblLessonsCount.text = [NSString stringWithFormat:@"%@ %ld/%ld",
                           MMLocalizedString(@"Question"),
                           (long)_currentQuestionIndex+1,
                           (long)_totalQuestionsCount];
}

#pragma mark - MMLessonLearningDelegate methods
- (void)questionContentViewDidSkipAnswer {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserDefSpeakEnabled];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [_answersData removeAllObjects];
  _vGestureLayer.hidden = YES;
  _currentQuestionIndex++;
  [self removeCurrentQuestion];
}

@end
