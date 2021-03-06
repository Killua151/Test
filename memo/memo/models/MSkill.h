//
//  MSkill.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MSkill : MBase

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSArray *coordinate;
@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, assign) NSInteger finished_lesson;
@property (nonatomic, strong) NSString *icon_name;
@property (nonatomic, strong) NSArray *lessons;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *objectives;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, strong) NSString *theme_color;
@property (nonatomic, assign) NSInteger strength;
@property (nonatomic, assign) BOOL allow_shortcut;
@property (nonatomic, assign) BOOL enabled;

- (UIColor *)themeColor;
- (BOOL)isFinished;

@end
