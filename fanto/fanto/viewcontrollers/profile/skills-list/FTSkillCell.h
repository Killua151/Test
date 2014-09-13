//
//  FTSkillCell.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface FTSkillCell : BaseTableViewCell

@property (nonatomic, assign) id<FTSkillViewDelegate> delegate;

+ (NSString *)reuseIdentifierForSkills:(NSArray *)skills;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateCellWithSkills:(NSArray *)skills;

@end
