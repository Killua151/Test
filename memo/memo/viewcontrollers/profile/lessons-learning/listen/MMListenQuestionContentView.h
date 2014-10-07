//
//  FTListenQuestionContentView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMQuestionContentView.h"

@interface MMListenQuestionContentView : MMQuestionContentView <UITextViewDelegate> {
  IBOutlet UILabel *_lblQuestionTitle;
  IBOutlet UIButton *_btnAudioNormal;
  IBOutlet UIButton *_btnAudioSlow;
  IBOutlet UIView *_vAnswerField;
  IBOutlet UIImageView *_imgAnswerFieldBg;
  IBOutlet UITextField *_txtAnswerPlaceholder;
  IBOutlet UITextView *_txtAnswerField;
}

- (IBAction)btnNormalAudioPressed:(UIButton *)sender;
- (IBAction)btnSlowAudioPressed:(UIButton *)sender;

@end
