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
#if kHexagonThemeDisplayMode
  return [MMHexagonCheckpointTestCell class];
#else
  return [MMShieldCheckpointTestCell class];
#endif
}

- (void)displayAds:(MAdsConfig *)adsConfig {
  // Implement in child class
}

@end
