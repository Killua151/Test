//
//  FTJudgeOptionCell.h
//  fanto
//
//  Created by Ethan Nguyen on 9/26/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMJudgeOptionCell : BaseTableViewCell {
  IBOutlet UIView *_vOptionBg;
  IBOutlet UIImageView *_imgCheckbox;
  IBOutlet UILabel *_lblOption;
}

@end
