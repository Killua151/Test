//
//  FTHexagonSkillView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTSkillView.h"

@class MSkill;

@interface FTHexagonSkillView : FTSkillView {
  IBOutlet UIImageView *_imgSkillBg;
  IBOutlet UIImageView *_imgSkillIcon;
  IBOutlet UILabel *_lblSkillName;
  IBOutlet UILabel *_lblLessonsProgress;
  IBOutlet UIImageView *_imgSkillStrength;
}

@end
