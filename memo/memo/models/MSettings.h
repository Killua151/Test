//
//  MSettings.h
//  memo
//
//  Created by Ethan Nguyen on 10/31/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MSettings : MBase

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *notification_title;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) BOOL push_notification_enabled;
@property (nonatomic, assign) BOOL email_notification_enabled;

@end
