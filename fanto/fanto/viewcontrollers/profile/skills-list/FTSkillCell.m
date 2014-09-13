//
//  FTSkillCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillCell.h"

@implementation FTSkillCell

+ (NSString *)reuseIdentifierForSkills:(NSArray *)skills {
  if ([skills count] == 0)
    return NSStringFromClass([self class]);
  
  NSMutableString *reuseId = [NSMutableString string];
  
  for (NSObject *skill in skills)
    [reuseId appendString:NSStringFromClass([skill class])];
  
  return reuseId;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
    LoadXibWithSameClass();
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
  }
  
  return self;
}

- (void)updateCellWithSkills:(NSArray *)skills {
  // Implement in child class
}

@end
