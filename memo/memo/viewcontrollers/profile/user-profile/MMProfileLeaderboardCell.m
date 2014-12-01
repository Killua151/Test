//
//  FTProfileLeaderboardCell.m
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMProfileLeaderboardCell.h"
#import "MLeaderboardData.h"
#import "MUser.h"

@implementation MMProfileLeaderboardCell

- (id)init {
  if (self = [super init]) {
    _imgAvatar.superview.layer.cornerRadius = _imgAvatar.frame.size.width/2;
    _lblUsername.font = [UIFont fontWithName:@"ClearSans" size:17];
    _lblUserExp.font = [UIFont fontWithName:@"ClearSans" size:17];
  }
  
  return self;
}

- (void)updateCellWithData:(MLeaderboardData *)data {
  [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:data.url_avatar]
                placeholderImage:[UIImage imageNamed:@"img-profile-avatar_placeholder.png"]];
  
  if ([data.user_id isEqualToString:[MUser currentUser]._id])
    _lblUsername.textColor = _lblUserExp.textColor = UIColorFromRGB(129, 12, 21);
  else
    _lblUsername.textColor = _lblUserExp.textColor = UIColorFromRGB(102, 102, 102);
  
  _lblUsername.text = data.username;
  _lblUserExp.text = [NSString stringWithFormat:@"%ld EXP", (long)data.earned_exp];
}

@end
