//
//  MTranslateQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MTranslateQuestion : MBaseQuestion

@property (nonatomic, strong) NSString *translation;
@property (nonatomic, strong) NSArray *alternative_answers;
@property (nonatomic, strong) NSArray *common_errors;
@property (nonatomic, strong) NSString *normal_question_audio;

@end
