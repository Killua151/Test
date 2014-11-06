//
//  FTHexagonSkillCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHexagonSkillCell.h"
#import "MMHexagonSkillView.h"
#import "MSkill.h"

@interface MMHexagonSkillCell ()

@end

@implementation MMHexagonSkillCell

//- (id)init {
//  if (self = [super init]) {
//    if (self.contentView.superview.clipsToBounds)
//      [self.contentView.superview setClipsToBounds:NO];
//    
//    DLog(@"%@ %@ %@ %@",
//         NSStringFromBOOL(self.clipsToBounds),
//         NSStringFromBOOL(self.contentView.clipsToBounds),
//         NSStringFromBOOL(self.contentView.superview.clipsToBounds),
//         NSStringFromBOOL(self.layer.masksToBounds));
//  }
//  
//  return self;
//}

- (CGFloat)yPosForSkillViews {
  return 8;
}

- (Class)skillViewClass {
  return [MMHexagonSkillView class];
}

@end
