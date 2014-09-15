//
//  FTHexagonSkillView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSkill;

@interface FTHexagonSkillView : UIView {
  IBOutlet UIImageView *_imgSkillBg;
  IBOutlet UIImageView *_imgSkillIcon;
  IBOutlet UILabel *_lblSkillName;
  IBOutlet UILabel *_lblLessonsProgress;
  IBOutlet UIImageView *_imgSkillStrength;
}

@property (nonatomic, assign) id<FTSkillViewDelegate> delegate;

- (id)initWithSkill:(MSkill *)skill andTarget:(id<FTSkillViewDelegate>)target;
- (void)populateData;
- (IBAction)btnSkillPressed:(UIButton *)sender;

@end
