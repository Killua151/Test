//
//  MAds.h
//  memo
//
//  Created by Ethan Nguyen on 11/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@class MAdsConfig;

@interface MAds : MBase

@property (nonatomic, strong) MAdsConfig *config;
@property (nonatomic, strong) NSString *screen;
@property (nonatomic, strong) NSString *position;

@end
