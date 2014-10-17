//
//  MMPlacementTestViewController.m
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMPlacementTestViewController.h"
#import "MMFinishLessonViewController.h"
#import "MMQuestionContentView.h"
#import "MBaseQuestion.h"

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
  if (_currentLessonIndex == 0) {
    [super prepareNextQuestion];
    return;
  }
  
  ShowHudForCurrentView();
  
  [[MMServerHelper sharedHelper]
   submitPlacementTestAnswer:_answersData
   withMetadata:_metadata
   completion:^(NSString *examToken, MBaseQuestion *question, BOOL isFinished, NSError *error) {
     HideHudForCurrentView();
     ShowAlertWithError(error);
     
     if (!isFinished) {
       _metadata[kParamExamToken] = examToken;
       [_questionsData addObject:question];
       [Utils preDownloadAudioFromUrls:[MBaseQuestion audioUrlsFromQuestions:@[question]]];
       [super prepareNextQuestion];
       return;
     }
     
     [self presentViewController:[MMFinishLessonViewController navigationController] animated:YES completion:NULL];
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
  _lblLessonsCount.text = [NSString stringWithFormat:@"%@ %ld", MMLocalizedString(@"Question"), (long)_currentLessonIndex+1];
}

#pragma mark - MMLessonLearningDelegate methods
- (void)questionContentViewDidSkipAnswer {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserDefSpeakEnabled];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [_answersData removeAllObjects];
  _vGestureLayer.hidden = YES;
  _currentLessonIndex++;
  [self removeCurrentQuestion];
}

@end
