//
//  MSelectQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBaseQuestion.h"

@interface MSelectQuestion : MBaseQuestion

@property (nonatomic, strong) NSString *hint;
@property (nonatomic, strong) NSArray *options;

@end
