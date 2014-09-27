//
//  MBaseQuestion.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MBaseQuestion : MBase

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *lang;

+ (Class)questionKlassByType:(NSString *)type;

@end
