//
//  MTranslateQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MTranslateQuestion : MBaseQuestion

@property (nonatomic, strong) NSString *answer_lang;
@property (nonatomic, strong) NSString *question_lang;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *translation;
@property (nonatomic, strong) NSArray *translations_group2;
@property (nonatomic, strong) NSArray *translations_group3;

@end
