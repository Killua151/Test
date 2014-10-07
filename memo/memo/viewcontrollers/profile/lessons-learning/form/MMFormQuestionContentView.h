//
//  FTFormQuestionContentView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMQuestionContentView.h"

@interface MMFormQuestionContentView : MMQuestionContentView <FTQuestionContentDelegate> {
  IBOutlet UILabel *_lblQuestionTitle;
  IBOutlet UIButton *_btnQuestionAudio;
  IBOutlet UILabel *_lblQuestion;
  IBOutlet UIView *_vAnsweredTokens;
  IBOutlet UIImageView *_imgAnswerFieldBg;
  IBOutlet UITextField *_txtAnswerPlaceholder;
  IBOutlet UIView *_vAvailableTokens;
}

@end
