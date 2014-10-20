//
//  MMWordDefinitionsView.h
//  memo
//
//  Created by Ethan Nguyen on 10/20/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMWordDefinitionsView : UIView <UITableViewDataSource, UITableViewDelegate> {
  IBOutlet UIImageView *_imgBg;
  IBOutlet UITableView *_tblDefinitions;
}

- (void)reloadContentsWithData:(NSArray *)definitions;

@end
