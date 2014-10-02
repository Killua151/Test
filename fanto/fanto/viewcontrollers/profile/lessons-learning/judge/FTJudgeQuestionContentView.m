//
//  FTJudgeQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTJudgeQuestionContentView.h"
#import "FTJudgeOptionCell.h"
#import "MJudgeQuestion.h"

@interface FTJudgeQuestionContentView () {
  NSArray *_optionsData;
  NSMutableArray *_answerIndices;
  NSMutableIndexSet *_answersIndexSet;
}

- (void)updateLessonLearningView;

@end

@implementation FTJudgeQuestionContentView

- (id)initWithQuestion:(MBaseQuestion *)question {
  if (self = [super initWithQuestion:question]) {
    _tblOptions.dataSource = self;
    _tblOptions.delegate = self;
  }
  
  return self;
}

- (void)setupViews {
  MJudgeQuestion *questionData = (MJudgeQuestion *)self.questionData;
  
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblQuestion.text = questionData.question;
  
  CGFloat maxQuestionHeight = _tblOptions.frame.origin.y - _lblQuestionTitle.frame.origin.y -
  _lblQuestionTitle.frame.size.height;
  [Utils adjustLabelToFitHeight:_lblQuestion constrainsToHeight:maxQuestionHeight];
  
  CGPoint center = _lblQuestion.center;
  center.y = _lblQuestionTitle.frame.origin.y + _lblQuestionTitle.frame.size.height + maxQuestionHeight/2;
  _lblQuestion.center = center;

  _optionsData = questionData.options;
  _answerIndices = [NSMutableArray new];
  _answersIndexSet = [NSMutableIndexSet indexSet];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_optionsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FTJudgeOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FTJudgeOptionCell class])];
  
  if (cell == nil)
    cell = [FTJudgeOptionCell new];
  
  [cell updateCellWithData:_optionsData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [FTJudgeOptionCell heightToFitWithData:_optionsData[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (![_answersIndexSet containsIndex:indexPath.row])
    [_answersIndexSet addIndex:indexPath.row];
  
  [self updateLessonLearningView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_answersIndexSet containsIndex:indexPath.row])
    [_answersIndexSet removeIndex:indexPath.row];
  
  [self updateLessonLearningView];
}

#pragma mark - Private methods
- (void)updateLessonLearningView {
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:withValue:)])
    [self.delegate questionContentViewDidUpdateAnswer:[_answersIndexSet count] > 0
                                            withValue:[_optionsData objectsAtIndexes:_answersIndexSet]];
}

@end
