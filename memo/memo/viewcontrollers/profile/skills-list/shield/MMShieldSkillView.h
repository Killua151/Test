//
//  FTShieldSkillView.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMSkillView.h"

@interface MMShieldSkillView : MMSkillView {
  IBOutlet UIImageView *_imgSkillBg;
  IBOutlet UIImageView *_imgSkillIcon;
  IBOutlet UILabel *_lblLessonsProgressed;
  IBOutlet UIImageView *_imgSkillStrength;
  IBOutlet UILabel *_lblSkillName;
}

@end
