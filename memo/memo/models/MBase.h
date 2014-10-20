//
//  MBase.h
//  fanto
//
//  Created by Ethan Nguyen on 9/13/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBase : NSObject

+ (instancetype)sharedModel;
+ (instancetype)modelFromDict:(NSDictionary *)modelDict;
+ (NSArray *)modelsFromArr:(NSArray *)modelsArr;
+ (DCKeyValueObjectMapping *)modelMappingParser;

@end
