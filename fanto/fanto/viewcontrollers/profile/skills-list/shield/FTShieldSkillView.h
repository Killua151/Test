//
//  FTShieldSkillView.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTShieldSkillView : UIView {
  IBOutlet UIImageView *_imgSkillBg;
  IBOutlet UIImageView *_imgSkillIcon;
  IBOutlet UILabel *_lblLessonsProgressed;
  IBOutlet UIImageView *_imgSkillStrength;
  IBOutlet UILabel *_lblSkillName;
}

@property (nonatomic, assign) id<FTSkillViewDelegate> delegate;

- (id)initWithSkill:(MSkill *)skill andTarget:(id<FTSkillViewDelegate>)target;
- (void)populateData;
- (IBAction)btnSkillPressed:(UIButton *)sender;

@end
