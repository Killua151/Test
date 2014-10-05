//
//  NSMutableArray+MutableArrayHelpers.m
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "NSMutableArray+MutableArrayHelpers.h"

@implementation NSMutableArray (MutableArrayHelpers)

- (void)shuffle {
  NSUInteger count = [self count];
  
  for (NSUInteger index = 0; index < count; index++) {
	NSInteger nElements = count - index;
	NSInteger n = (arc4random() % nElements) + index;
	[self exchangeObjectAtIndex:index withObjectAtIndex:n];
  }
}

@end
