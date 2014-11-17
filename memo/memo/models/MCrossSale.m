//
//  MCrossSale.m
//  memo
//
//  Created by Ethan Nguyen on 11/15/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MCrossSale.h"

@implementation MCrossSale

+ (instancetype)sharedCrossSale {
  static MCrossSale *_sharedCrossSale = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedCrossSale = [MCrossSale new];
  });
  
  return _sharedCrossSale;
}

@end
