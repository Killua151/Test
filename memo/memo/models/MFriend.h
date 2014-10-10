//
//  MFindFriend.h
//  memo
//
//  Created by Ethan Nguyen on 10/10/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MFriend : MBase

@property (nonatomic, assign) BOOL is_following;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *url_avatar;

@end
