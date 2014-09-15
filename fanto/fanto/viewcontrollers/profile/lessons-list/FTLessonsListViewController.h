//
//  FTLessonsListViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@class MSkill;

@interface FTLessonsListViewController : BaseViewController

@property (nonatomic, strong) MSkill *skillData;

+ (Class)currentLessonsListClass;
- (UIColor *)navigationTextColor;

@end
