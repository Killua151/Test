//
//  FTCourseSelectionCell.m
//  fanto
//
//  Created by Ethan Nguyen on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMCourseSelectionCell.h"
#import "MCourse.h"

@implementation MMCourseSelectionCell

- (id)init {
  if (self = [super init]) {
    _btnCourse.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
    _btnCourse.layer.cornerRadius = 4;
  }
  
  return self;
}

- (void)updateCellWithData:(MCourse *)data {
  [_btnCourse setTitle:data.name forState:UIControlStateNormal];
}

@end
