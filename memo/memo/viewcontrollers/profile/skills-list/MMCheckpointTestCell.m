//
//  FTCheckpointTestCell.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMCheckpointTestCell.h"
#import "MMHexagonCheckpointTestCell.h"
#import "MMShieldCheckpointTestCell.h"

@implementation MMCheckpointTestCell

+ (Class)currentCheckpointTestCellClass {
#if kHexagonThemeTestMode
  return [MMHexagonCheckpointTestCell class];
#else
  return [FTShieldCheckpointTestCell class];
#endif
}

@end
