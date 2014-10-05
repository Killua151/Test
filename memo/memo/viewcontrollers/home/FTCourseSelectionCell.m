//
//  FTCourseSelectionCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTCourseSelectionCell.h"

@implementation FTCourseSelectionCell

- (id)init {
  if (self = [super init]) {
    _btnCourse.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
    _btnCourse.layer.cornerRadius = 4;
  }
  
  return self;
}

- (void)updateCellWithData:(NSString *)data {
  [_btnCourse setTitle:data forState:UIControlStateNormal];
}

@end
