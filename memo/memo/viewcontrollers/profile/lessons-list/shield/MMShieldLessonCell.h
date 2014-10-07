//
//  FTShieldLessonCell.h
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMShieldLessonCell : BaseTableViewCell {
  IBOutlet UIView *_vLesson;
  IBOutlet UIImageView *_imgPassCheckmark;
  IBOutlet UILabel *_lblLessonTitle;
  IBOutlet UILabel *_lblObjectives;
  IBOutlet UIButton *_btnRetake;
}

- (IBAction)btnRetakePressed:(UIButton *)sender;

@end
