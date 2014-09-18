//
//  MUser.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MUser : MBase

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *fb_id;
@property (nonatomic, strong) NSString *fb_access_token;
@property (nonatomic, strong) NSString *gg_email;
@property (nonatomic, strong) NSString *gg_access_token;

+ (void)loadCurrentUserFromUserDef;
+ (void)logOutCurrentUser;
+ (instancetype)currentUser;

@end
