//
//  FTSkillView.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSkill;

@interface MMSkillView : UIView {
  MSkill *_skillData;
}

@property (nonatomic, assign) id<FTSkillViewDelegate> delegate;

+ (Class)currentSkillViewClass;
- (id)initWithTarget:(id<FTSkillViewDelegate>)target;
- (void)populateViewWithData:(MSkill *)skill;

- (IBAction)btnSkillPressed:(UIButton *)sender;

@end
