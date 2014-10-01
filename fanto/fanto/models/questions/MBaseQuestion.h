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
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *type;

+ (Class)questionKlassByType:(NSString *)type;
- (id)checkAnswer:(id)answerValue;

@end