//
//  FTNameQuestionContentView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTQuestionContentView.h"

@interface FTNameQuestionContentView : FTQuestionContentView <UITextFieldDelegate, UITextViewDelegate> {
  IBOutlet UILabel *_lblQuestion;
  IBOutlet UIImageView *_imgQuestion;
  IBOutlet UIView *_vAnswerField;
  IBOutlet UITextField *_txtAnswerField;
}

@end
