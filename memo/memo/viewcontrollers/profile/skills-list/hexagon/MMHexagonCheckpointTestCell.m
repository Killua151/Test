//
//  FTHexagonCheckpointTestCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHexagonCheckpointTestCell.h"
#import "MUser.h"

@implementation MMHexagonCheckpointTestCell

- (id)init {
  if (self = [super init]) {
    _btnCheckpointTest.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:14];
  }
  
  return self;
}

- (void)updateCellWithData:(NSNumber *)data {
  NSInteger numberOfLockedSkills = [[MUser currentUser] numberOfLockedSkillsForCheckpoint:[data integerValue]];
  
  if (numberOfLockedSkills <= 0) {
    [_btnCheckpointTest setTitle:MMLocalizedString(@"Checkpoint passed") forState:UIControlStateNormal];
    _btnCheckpointTest.enabled = NO;
    return;
  }
  
  NSString *suffix = numberOfLockedSkills == 1 ? MMLocalizedString(@"skill") : MMLocalizedString(@"skills");
  NSString *checkpointTitle = [NSString stringWithFormat:
                               MMLocalizedString(@"Checkpoint test for %d %@"), numberOfLockedSkills, suffix];
  [_btnCheckpointTest setTitle:checkpointTitle forState:UIControlStateNormal];
}

@end
