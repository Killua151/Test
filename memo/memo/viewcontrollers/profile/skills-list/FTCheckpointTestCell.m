//
//  FTCheckpointTestCell.m
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTCheckpointTestCell.h"
#import "FTHexagonCheckpointTestCell.h"
#import "FTShieldCheckpointTestCell.h"

@implementation FTCheckpointTestCell

+ (Class)currentCheckpointTestCellClass {
#if kHexagonThemeTestMode
  return [FTHexagonCheckpointTestCell class];
#else
  return [FTShieldCheckpointTestCell class];
#endif
}

@end
