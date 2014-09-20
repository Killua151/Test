//
//  FTProfileLeaderboardCell.m
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTProfileLeaderboardCell.h"

@implementation FTProfileLeaderboardCell

- (id)init {
  if (self = [super init]) {
    _imgAvatar.superview.layer.cornerRadius = _imgAvatar.frame.size.width/2;
    _lblUsername.font = [UIFont fontWithName:@"ClearSans" size:17];
    _lblUserXp.font = [UIFont fontWithName:@"ClearSans" size:17];
  }
  
  return self;
}

- (void)updateCellWithData:(NSString *)data {
  _lblUsername.text = data;
}

@end
