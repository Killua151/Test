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

@end
