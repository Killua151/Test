//
//  NSObject+ObjectMapping.h
//  fanto
//
//  Created by Ethan Nguyen on 10/1/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ObjectMapping)

- (void)assignProperties:(NSDictionary *)dict;
+ (NSArray *)allPropertiesList;
+ (NSDictionary *)allPropertiesWithType;

@end
