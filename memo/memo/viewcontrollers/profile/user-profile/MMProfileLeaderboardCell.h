//
//  FTProfileLeaderboardCell.h
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MMProfileLeaderboardCell : BaseTableViewCell {
  IBOutlet UIImageView *_imgAvatar;
  IBOutlet UILabel *_lblUsername;
  IBOutlet UILabel *_lblUserExp;
}

@end
