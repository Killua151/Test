//
//  FTHexagonSkillCell.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface FTHexagonSkillCell : BaseTableViewCell <FTSkillViewDelegate>

+ (NSString *)reuseIdentifierForSkills:(NSArray *)skills;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateCellWithSkills:(NSArray *)skills;

@end
