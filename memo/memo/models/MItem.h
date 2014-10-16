//
//  MItem.h
//  fanto
//
//  Created by Ethan on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MBase.h"

@interface MItem : MBase

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, assign) BOOL can_buy;
@property (nonatomic, strong) NSString *can_not_buy_message;
@property (nonatomic, assign) BOOL consumable;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString *section;

+ (NSDictionary *)itemsBySectionsFromArr:(NSArray *)itemsArr;

@end
