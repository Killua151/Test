//
//  NSArray+ArrayHelpers.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "NSArray+ArrayHelpers.h"

@implementation NSArray (ArrayHelpers)

- (NSArray *)shuffledArray {
  NSMutableArray *selfArr = [NSMutableArray arrayWithArray:self];
  [selfArr shuffle];
  
  return [NSArray arrayWithArray:selfArr];
}

@end
