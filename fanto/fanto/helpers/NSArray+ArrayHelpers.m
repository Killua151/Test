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

- (NSString *)componentsJoinedByString:(NSString *)separator withSpecialStringForLastItem:(NSString *)specialSeparator {
  if ([self count] == 0)
    return @"";
  
  if (specialSeparator == nil)
    return [self componentsJoinedByString:separator];
  
  if ([self count] == 1)
    return [self firstObject];
  
  NSArray *subArray = [self subarrayWithRange:NSMakeRange(0, [self count]-1)];
  
  return [NSString stringWithFormat:@"%@ %@ %@",
          [subArray componentsJoinedByString:separator], specialSeparator, [self lastObject]];
}

@end
