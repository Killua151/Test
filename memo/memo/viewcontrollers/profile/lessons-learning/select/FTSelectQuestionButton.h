//
//  FTJudgeButtonView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTSelectQuestionButton : UIView {
  IBOutlet UIImageView *_imgOptionImage;
  IBOutlet UIImageView *_imgRadio;
  IBOutlet UILabel *_lblOptionTitle;
  IBOutlet UIButton *_btnGesture;
}

@property (nonatomic, assign) id<FTQuestionContentDelegate> delegate;

- (id)initWithTitle:(NSString *)title atIndex:(NSInteger)index;
- (void)setSelected:(BOOL)selected;

- (IBAction)btnGestureTouchedDown:(UIButton *)sender;
- (IBAction)btnGesturePressed:(UIButton *)sender;
- (IBAction)btnGestureTouchedUpOutside:(UIButton *)sender;

@end
