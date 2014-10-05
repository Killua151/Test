//
//  MABaseTableViewCell.h
//  medicine-alert
//
//  Created by Ethan Nguyen on 7/1/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBase;

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellIndex;

+ (CGFloat)heightToFitWithData:(MBase *)data;
- (void)updateCellWithData:(MBase *)data;
- (void)updateCellWithData:(MBase *)data atIndex:(NSInteger)cellIndex;
- (void)updateCellWithData:(NSString *)data shouldShowSeparator:(BOOL)shouldShowSeparator;
- (CGFloat)heightToFit;

@end
