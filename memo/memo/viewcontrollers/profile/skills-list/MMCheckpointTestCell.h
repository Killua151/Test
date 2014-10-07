//
//  FTCheckpointTestCell.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMCheckpointTestCell : BaseTableViewCell {
  IBOutlet UILabel *_lblCheckpointTestTitle;
}

+ (Class)currentCheckpointTestCellClass;

@end
