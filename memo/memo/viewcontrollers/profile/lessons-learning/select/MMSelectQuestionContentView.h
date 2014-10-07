//
//  FTJudgeQuestionView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/25/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMQuestionContentView.h"

@interface MMSelectQuestionContentView : MMQuestionContentView <FTQuestionContentDelegate> {
  IBOutlet UILabel *_lblQuestion;
}

@end
