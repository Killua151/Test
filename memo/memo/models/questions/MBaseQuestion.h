//
//  MBaseQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MBaseQuestion : MBase

@property (nonatomic, strong) NSArray *objectives;
@property (nonatomic, strong) NSArray *special_objectives;
@property (nonatomic, strong) NSString *question_log_id;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *type;

+ (Class)questionKlassByType:(NSString *)type;
+ (NSArray *)audioUrlsFromQuestions:(NSArray *)questions;
- (NSDictionary *)checkAnswer:(id)answerValue;
- (NSDictionary *)checkUserAnswer:(NSString *)userAnswer
               withCorrectAnswers:(NSArray *)correctAnswers
                  andCommonErrors:(NSArray *)commonErrors
                 shouldCheckTypos:(BOOL)checkTypos;

@end
