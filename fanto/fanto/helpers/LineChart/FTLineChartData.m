//
//  FTLineChartData.m
//  SPChartLib
//
//  Created by Alessandro Calzavara on 06/14/14.
//  Copyright (c) 2014 Alessandro Calzavara. All rights reserved.
//

#import "FTLineChartData.h"

@interface FTLineChartData ()

@property (nonatomic, strong, readwrite) NSArray * values;

@end

@implementation FTLineChartData

@synthesize pointStyle = _pointStyle;
@synthesize pointWidth = _pointWidth;
@synthesize lineWidth = _lineWidth;
@synthesize values = _values;

- (id)init
{
  self = [super init];
  if (self) {
    [self _setup];
  }
  
  return self;
}

- (void)_setup
{
  _pointStyle = SPLineChartPointStyleNone;
  _pointWidth = 6.f;
  _lineWidth = 2.f;
}

+ (instancetype)dataWithValues:(NSArray *)values color:(UIColor *)color
{
  return [self dataWithValues:values color:color pointStyle:SPLineChartPointStyleNone];
}

+ (instancetype)dataWithValues:(NSArray *)values color:(UIColor *)color pointStyle:(SPLineChartPointStyle)pointStyle
{
  FTLineChartData * data = [FTLineChartData new];
  
  data.values = values;
  data.color = color;
  data.pointStyle = pointStyle;
  
  return data;
}

- (BOOL)isEmpty
{
  __block BOOL empty = YES;
  
  [self.values enumerateObjectsUsingBlock:^(NSNumber * value, NSUInteger idx, BOOL *stop) {
    
    empty = ([value integerValue] == 0);
    *stop = !empty;
    
  }];
  
  return empty;
}

- (NSInteger)maxValue
{
  __block NSInteger max = 0;
  
  [self.values enumerateObjectsUsingBlock:^(NSNumber * value, NSUInteger idx, BOOL *stop) {
    
    max = MAX(max, [value integerValue]);
    
  }];
  
  return max;
}

@end