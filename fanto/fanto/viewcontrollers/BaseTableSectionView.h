//
//  BaseTableSectionView.h
//  fanto
//
//  Created by Ethan Nguyen on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableSectionView : UIView

+ (CGFloat)heightToFithWithData:(id)data;
- (void)updateViewWithData:(id)data;
- (CGFloat)heightToFit;

@end
