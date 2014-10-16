//
//  FTShopViewController.h
//  fanto
//
//  Created by Ethan Nguyen on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseViewController.h"

@interface MMShopViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MMShopDelegate> {
  IBOutlet UITableView *_tblItems;
  IBOutlet UIView *_vHeader;
  IBOutlet UILabel *_lblMoneyBalanceInfo;
}

@end
