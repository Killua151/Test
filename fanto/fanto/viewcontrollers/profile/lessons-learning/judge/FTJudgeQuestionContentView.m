//
//  FTJudgeQuestionContentView.m
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTJudgeQuestionContentView.h"
#import "FTJudgeOptionCell.h"

@interface FTJudgeQuestionContentView () {
  NSArray *_optionsData;
  NSMutableArray *_answersData;
}

- (void)updateLessonLearningView;

@end

@implementation FTJudgeQuestionContentView

- (id)init {
  if (self = [super init]) {
    _tblOptions.dataSource = self;
    _tblOptions.delegate = self;
  }
  
  return self;
}

- (void)setupViews {
  _optionsData = @[@"We eat rice", @"We drink water", @"We drink break"];
  _answersData = [NSMutableArray new];
  
  _lblQuestionTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblQuestion.font = [UIFont fontWithName:@"ClearSans" size:17];
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
  if (![_answersData containsObject:@(indexPath.row)])
    [_answersData addObject:@(indexPath.row)];
  
  [self updateLessonLearningView];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_answersData containsObject:@(indexPath.row)])
    [_answersData removeObject:@(indexPath.row)];
  
  [self updateLessonLearningView];
}

#pragma mark - Private methods
- (void)updateLessonLearningView {
  if ([self.delegate respondsToSelector:@selector(questionContentViewDidUpdateAnswer:)])
    [self.delegate questionContentViewDidUpdateAnswer:[_answersData count] > 0];
}

@end
