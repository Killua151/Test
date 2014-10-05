//
//  MLessons.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MLesson : MBase

@property (nonatomic, assign) NSInteger lesson_number;
@property (nonatomic, strong) NSArray *objectives;

@end
