//
//  MJudgeQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 10/2/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MJudgeQuestion : MBaseQuestion

@property (nonatomic, strong) NSArray *hints;
@property (nonatomic, strong) NSArray *options;

@end
