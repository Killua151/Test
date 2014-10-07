//
//  FTShopItemCell.h
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMShopItemCell : BaseTableViewCell {
  IBOutlet UIImageView *_imgItemIcon;
  IBOutlet UILabel *_lblItemName;
  IBOutlet UILabel *_lblItemDescription;
  IBOutlet UIButton *_btnPrice;
}

- (IBAction)btnPricePressed:(UIButton *)sender;

@end
