//
//  MBaseQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MBaseQuestion : MBase

@property (nonatomic, strong) NSString *question_log_id;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *type;

+ (Class)questionKlassByType:(NSString *)type;
+ (NSArray *)audioUrlsFromQuestions:(NSArray *)questions;
- (id)checkAnswer:(id)answerValue;

@end
