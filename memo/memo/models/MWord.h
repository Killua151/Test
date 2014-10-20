//
//  MWord.h
//  memo
//
//  Created by Ethan Nguyen on 10/20/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MBase.h"

@interface MWord : MBase

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSArray *definitions;
@property (nonatomic, strong) NSString *sound;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong, readonly) NSMutableDictionary *dictionary;

- (void)setupDictionary:(NSDictionary *)dictionary;

@end
