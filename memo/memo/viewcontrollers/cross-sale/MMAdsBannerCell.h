//
//  MMAdsBannerCell.h
//  memo
//
//  Created by Ethan Nguyen on 11/17/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "BaseTableViewCell.h"

@class MAdsConfig, MMAdsBannerView;

@interface MMAdsBannerCell : BaseTableViewCell <MMCrossSaleAdsDelegate> {
  MMAdsBannerView *_vAdsBanner;
}

@property (nonatomic, assign) id<MMCrossSaleAdsDelegate> delegate;

@end
