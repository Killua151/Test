//
//  MMAdsPopupView.h
//  memo
//
//  Created by Ethan Nguyen on 11/17/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMAdsItemView, MAdsConfig;

@interface MMAdsPopupView : UIView {
  IBOutlet UIView *_vAdsContent;
  IBOutlet UIButton *_btnClose;
}

- (id)initWithAds:(MAdsConfig *)ads;
- (IBAction)btnClosePressed:(UIButton *)sender;

@end
