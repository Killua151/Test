//
//  FTSharedHeader.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MSkill;

@protocol FTSkillViewDelegate <NSObject>

@optional
- (void)skillViewDidSelectSkill:(MSkill *)skill;

@end
