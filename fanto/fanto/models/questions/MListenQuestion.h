//
//  MListenQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MListenQuestion : MBaseQuestion

@property (nonatomic, strong) NSString *normal_question_audio;
@property (nonatomic, strong) NSString *slow_question_audio;

@end
