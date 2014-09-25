//
//  FTJudgeButtonView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTJudgeButtonView : UIView {
  IBOutlet UIImageView *_imgOptionImage;
  IBOutlet UIImageView *_imgRadio;
  IBOutlet UILabel *_lblOptionTitle;
}

@property (nonatomic, assign) id<FTLessonLearningDelegate> delegate;

- (id)initWithIndex:(NSInteger)index;

- (IBAction)btnGestureTouchedDown:(UIButton *)sender;
- (IBAction)btnGesturePressed:(UIButton *)sender;
- (IBAction)btnGestureTouchedUpOutside:(UIButton *)sender;

@end
