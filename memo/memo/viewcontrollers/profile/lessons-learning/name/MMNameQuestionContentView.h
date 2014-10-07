//
//  FTNameQuestionContentView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMQuestionContentView.h"

@interface MMNameQuestionContentView : MMQuestionContentView <UITextFieldDelegate, UITextViewDelegate> {
  IBOutlet UILabel *_lblQuestion;
  IBOutlet UIView *_vQuestion;
  IBOutletCollection(UIView) NSArray *_vQuestionImages;
  IBOutletCollection(UIImageView) NSArray *_imgQuestionImages;
  IBOutlet UIView *_vAnswerField;
  IBOutlet UITextField *_txtAnswerField;
}

@end
