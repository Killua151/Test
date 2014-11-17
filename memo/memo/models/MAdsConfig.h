//
//  MAdsConfig.h
//  memo
//
//  Created by Ethan Nguyen on 11/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MAdsConfig : MBase

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *display_type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end
