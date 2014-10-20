//
//  MMWordDefinitionsView.m
//  memo
//
//  Created by Ethan Nguyen on 10/20/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMWordDefinitionsView.h"

@interface MMWordDefinitionsView () {
  NSMutableArray *_definitionsData;
}

@end

@implementation MMWordDefinitionsView

- (id)init {
  if (self = [super init]) {
    LoadXibWithSameClass();
    _tblDefinitions.dataSource = self;
    _tblDefinitions.delegate = self;
    _imgBg.image = [_imgBg.image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 10, 10)];
  }
  
  return self;
}

- (void)reloadContentsWithData:(NSArray *)definitions {
  if (_definitionsData == nil)
    _definitionsData = [NSMutableArray new];
  
  [_definitionsData removeAllObjects];
  [_definitionsData addObjectsFromArray:definitions];
  [_tblDefinitions reloadData];
  
  CGRect frame = self.frame;
  frame.size.height = MIN(3, [definitions count]) * 44;
  self.frame = frame;
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_definitionsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
    cell.textLabel.textColor = UIColorFromRGB(102, 102, 102);
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 11.0/17;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    CGRect frame = cell.textLabel.frame;
    frame.origin.y += kFontClearSansMarginTop;
    cell.textLabel.frame = frame;
  }
  
  cell.textLabel.text = _definitionsData[indexPath.row];
  [cell.textLabel sizeToFit];
  
  return cell;
}

#pragma mark - UITableViewDelgate methods

@end
