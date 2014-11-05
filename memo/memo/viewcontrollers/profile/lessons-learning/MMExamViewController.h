//
//  FTLessonLearningViewController.h
//  fanto
//
//  Created by Ethan on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@class MMQuestionContentView;

@interface MMExamViewController : BaseViewController <MMLessonLearningDelegate, UIGestureRecognizerDelegate> {
  IBOutlet UIView *_vHeader;
  IBOutlet UILabel *_lblLessonsCount;
  IBOutlet UIView *_vHearts;
  IBOutletCollection(UIButton) NSArray *_btnHearts;
  IBOutlet UIButton *_btnHealthPotion;
  IBOutlet UIImageView *_imgAntProgressIndicator;
  IBOutletCollection(UIButton) NSArray *_btnProgressSegments;
  
  IBOutlet UIView *_vContentView;
  IBOutlet UIButton *_btnCheck;
  
  IBOutlet UIView *_vResultPopup;
  IBOutlet UIView *_vResultPopupBg;
  IBOutlet UIImageView *_imgResultPopupIcon;
  IBOutlet UILabel *_lblResultPopupMessage;
  IBOutlet UILabel *_lblResultPopupAnswer;
  
  IBOutlet UILabel *_lblAppVersion;
  
  MMQuestionContentView *_vQuestionContent;
  
  NSInteger _currentQuestionIndex;
  NSMutableDictionary *_metadata;
  NSMutableArray *_questionsData;
  NSMutableDictionary *_answersData;
}

- (id)initWithQuestions:(NSArray *)questions andMetadata:(NSDictionary *)metadata;
- (id)initWithQuestions:(NSArray *)questions
         maxHeartsCount:(NSInteger)maxHeartsCount
         availableItems:(NSDictionary *)availableItems
            andMetadata:(NSDictionary *)metadata;
- (IBAction)btnClosePressed:(UIButton *)sender;
- (IBAction)btnHealthPotionPressed:(UIButton *)sender;
- (IBAction)btnCheckPressed:(UIButton *)sender;
- (void)questionContentViewGestureLayerDidTap;

- (void)prepareNextQuestion;
- (void)checkCurrentQuestion;
- (void)removeCurrentQuestion;
- (void)updateHeaderViews;
- (void)switchCheckButtonMode:(BOOL)useToCheck;

@end
