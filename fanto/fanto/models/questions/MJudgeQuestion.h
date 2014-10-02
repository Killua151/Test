//
//  MJudgeQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MJudgeQuestion : MBaseQuestion

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *hint;
@property (nonatomic, strong) NSArray *option;

//@property (nonatomic, strong) NSString *question_audio;
//@property (nonatomic, strong) NSString *slow_audio_file;

@end
