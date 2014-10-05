//
//  FTJudgeQuestionContentView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTQuestionContentView.h"

@interface FTJudgeQuestionContentView : FTQuestionContentView <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UILabel *_lblQuestionTitle;
  IBOutlet UILabel *_lblQuestion;
  IBOutlet UITableView *_tblOptions;
}

@end
