//
//  FTShopSectionView.h
//  fanto
//
//  Created by Ethan on 9/16/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTShopSectionView : UIView {
  IBOutlet UILabel *_lblSectionName;
}

+ (CGFloat)heightToFithWithData:(NSString *)data;
- (void)updateViewWithData:(NSString *)data;

@end
