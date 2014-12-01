//
//  MMFindFriendCell.m
//  memo
//
//  Created by Ethan Nguyen on 10/10/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMFindFriendCell.h"
#import "MFriend.h"

@interface MMFindFriendCell () {
  MFriend *_friendData;
}

@end

@implementation MMFindFriendCell

- (id)init {
  if (self = [super init]) {
    _imgAvatar.superview.layer.cornerRadius = _imgAvatar.frame.size.width/2;
    _lblUsername.font = [UIFont fontWithName:@"ClearSans" size:17];
    _btnInteraction.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:13];
    _btnInteraction.layer.cornerRadius = 4;
  }
  
  return self;
}

- (void)updateCellWithData:(MFriend *)data {
  _friendData = data;
  
  [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:_friendData.url_avatar]
                placeholderImage:[UIImage imageNamed:@"img-profile-avatar_placeholder.png"]];
  
  NSString *interactionTitle = _friendData.is_following ? @"UNFOLLOW" : @"FOLLOW";
  [_btnInteraction setTitle:MMLocalizedString(interactionTitle) forState:UIControlStateNormal];
  [Utils adjustButtonToFitWidth:_btnInteraction padding:16 constrainsToWidth:110];
  
  CGRect frame = _btnInteraction.frame;
  frame.origin.x = self.frame.size.width - 15 - frame.size.width;
  _btnInteraction.frame = frame;
  _btnInteraction.tag = _friendData.is_following;
  
  _lblUsername.text = _friendData.username;
  
  frame = _lblUsername.frame;
  frame.size.width = _btnInteraction.frame.origin.x - frame.origin.x - 12;
  _lblUsername.frame = frame;
}

- (IBAction)btnInteractionPressed:(UIButton *)sender {
  sender.tag = !sender.tag;
  
  if ([_delegate respondsToSelector:@selector(interactFriend:toFollow:atIndex:)])
    [_delegate interactFriend:_friendData.user_id toFollow:sender.tag atIndex:_index];
}

@end
