//
//  MFormQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MSortQuestion : MBaseQuestion

@property (nonatomic, strong) NSArray *tokens;
@property (nonatomic, strong) NSArray *wrong_tokens;
@property (nonatomic, strong) NSString *normal_answer_audio;

@end
