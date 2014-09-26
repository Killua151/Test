//
//  FTListenQuestionContentView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTQuestionContentView.h"

@interface FTListenQuestionContentView : FTQuestionContentView <UITextViewDelegate> {
  IBOutlet UILabel *_lblQuestionTitle;
  IBOutlet UIButton *_btnAudioNormal;
  IBOutlet UIButton *_btnAudioSlow;
  IBOutlet UIView *_vAnswerField;
  IBOutlet UIImageView *_imgAnswerFieldBg;
  IBOutlet UITextView *_txtAnswerField;
}

@end
