//
//  FTSpeakQuestionContentView.h
//  fanto
//
//  Created by Ethan on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTQuestionContentView.h"

@interface FTSpeakQuestionContentView : FTQuestionContentView {
  IBOutlet UILabel *_lblQuestionTitle;
  IBOutlet UIButton *_btnQuestionAudio;
  IBOutlet UILabel *_lblQuestion;
  IBOutlet UIButton *_btnTooltips;
  IBOutlet UIButton *_btnRecord;
  IBOutlet UIButton *_btnSkipSpeakQuestion;
}

- (IBAction)btnTooltipsPressed:(UIButton *)sender;
- (IBAction)btnRecordTouchedDown:(UIButton *)sender;
- (IBAction)btnRecordPressed:(UIButton *)sender;
- (IBAction)btnSkipSpeakQuestionPressed:(UIButton *)sender;

@end
