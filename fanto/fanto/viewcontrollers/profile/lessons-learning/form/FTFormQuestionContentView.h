//
//  FTFormQuestionContentView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTQuestionContentView.h"

@interface FTFormQuestionContentView : FTQuestionContentView {
  IBOutlet UILabel *_lblQuestionTitle;
  IBOutlet UILabel *_lblQuestion;
  IBOutlet UIView *_vAnswerField;
  IBOutlet UIImageView *_imgAnswerFieldBg;
  IBOutlet UITextField *_txtAnswerPlaceholder;
}

@end
