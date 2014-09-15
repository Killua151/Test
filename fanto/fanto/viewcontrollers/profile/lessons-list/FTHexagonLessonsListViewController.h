//
//  FTLessonsListViewController.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@class MSkill;

@interface FTHexagonLessonsListViewController : BaseViewController <UIScrollViewDelegate> {
  IBOutlet UIImageView *_imgSkillIcon;
  IBOutlet UIScrollView *_vLessonsScrollView;
}

@property (nonatomic, strong) MSkill *skillData;

@end
