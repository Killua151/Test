//
//  FTHexagonCheckpointTestCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHexagonCheckpointTestCell.h"
#import "MUser.h"
#import "MCheckpoint.h"

@implementation MMHexagonCheckpointTestCell

- (id)init {
  if (self = [super init]) {
    _btnCheckpointTest.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
  }
  
  return self;
}

- (void)updateCellWithData:(NSNumber *)data {
  NSInteger numberOfLockedSkills = [[MUser currentUser] numberOfLockedSkillsForCheckpoint:[data integerValue]];
  MCheckpoint *checkpoint = [[MUser currentUser] checkpointForPosition:[data integerValue]];
  
  _btnCheckpointTest.enabled = numberOfLockedSkills > 0 && checkpoint.remaining_test_times > 0;
  
  if (numberOfLockedSkills <= 0) {
    [_btnCheckpointTest setTitle:MMLocalizedString(@"Checkpoint passed") forState:UIControlStateNormal];
    return;
  }
  
  if (checkpoint.remaining_test_times <= 0) {
    [_btnCheckpointTest setTitle:MMLocalizedString(@"Hết lượt làm checkpoint") forState:UIControlStateNormal];
    return;
  }
  
  NSString *suffix = numberOfLockedSkills == 1 ? MMLocalizedString(@"skill") : MMLocalizedString(@"skills");
  NSString *checkpointTitle = [NSString stringWithFormat:
                               MMLocalizedString(@"Checkpoint test for %d %@"), numberOfLockedSkills, suffix];
  [_btnCheckpointTest setTitle:checkpointTitle forState:UIControlStateNormal];
}

@end
