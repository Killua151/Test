//
//  MTranslateQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MTranslateQuestion : MBaseQuestion

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *translation;
@property (nonatomic, strong) NSArray *compact_translations;
@property (nonatomic, strong) NSArray *common_errors;

@end
