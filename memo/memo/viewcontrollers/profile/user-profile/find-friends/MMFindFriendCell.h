//
//  MMFindFriendCell.h
//  memo
//
//  Created by Ethan Nguyen on 10/10/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMFindFriendCell : BaseTableViewCell {
  IBOutlet UIImageView *_imgAvatar;
  IBOutlet UILabel *_lblUsername;
  IBOutlet UIButton *_btnInteraction;
}

@property (nonatomic, assign) id<MMFindFriendDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

- (IBAction)btnInteractionPressed:(UIButton *)sender;

@end
