//
//  MItem.m
//  fanto
//
//  Created by Ethan on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MItem.h"

@implementation MItem

+ (NSDictionary *)itemsBySectionsFromArr:(NSArray *)itemsArr {
  NSMutableDictionary *sections = [NSMutableDictionary dictionary];
  
  NSArray *items = [MItem modelsFromArr:itemsArr];
  
  for (MItem *item in items) {
    if (sections[item.section] == nil)
      sections[item.section] = [NSMutableArray array];
    
    [sections[item.section] addObject:item];
  }
  
  return sections;
}

+ (BOOL)checkItemAvailability:(NSString *)itemId inAvailableItems:(NSDictionary *)availableItems {
  if (availableItems == nil || ![availableItems isKindOfClass:[NSDictionary class]])
    return NO;
  
  if (availableItems[itemId] == nil || ![availableItems[itemId] isKindOfClass:[NSNumber class]])
    return NO;
  
  return [availableItems[itemId] integerValue] > 0;
}

+ (NSDictionary *)useItem:(NSString *)itemId inAvailableItems:(NSDictionary *)availableItems {
  if (availableItems == nil || ![availableItems isKindOfClass:[NSDictionary class]])
    return availableItems;
  
  if (availableItems[itemId] == nil || ![availableItems[itemId] isKindOfClass:[NSNumber class]] ||
      [availableItems[itemId] integerValue] <= 0)
    return availableItems;
  
  NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:availableItems];
  NSInteger quantity = [result[itemId] integerValue];
  result[itemId] = @(quantity-1);
  
  return [NSDictionary dictionaryWithDictionary:result];
}

@end
