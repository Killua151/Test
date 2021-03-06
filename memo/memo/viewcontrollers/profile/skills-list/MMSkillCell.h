//
//  FTSkillCell.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMSkillCell : BaseTableViewCell

@property (nonatomic, assign) id<MMSkillViewDelegate> delegate;

+ (Class)currentSkillCellClass;
+ (NSString *)reuseIdentifierForSkills:(NSArray *)skills;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                    withTotal:(NSInteger)totalSkills
                     inTarget:(id<MMSkillViewDelegate>)target;
- (void)updateCellWithSkills:(NSArray *)skills;
- (CGFloat)xCenterForSkillAtIndex:(NSInteger)index amongTotal:(NSInteger)total;
- (CGFloat)yPosForSkillViews;

@end
