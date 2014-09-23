//
//  FTActionSheet.h
//  fanto
//
//  Created by Ethan Nguyen on 9/23/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTShareActionSheet : UIView {
  IBOutlet UIView *_vBackground;
  IBOutlet UIView *_vMain;
  IBOutlet UIButton *_btnFacebook;
  IBOutlet UIButton *_btnGoogle;
  IBOutlet UIButton *_btnTwitter;
}

@property (nonatomic, assign) id<FTActionSheetDelegate> delegate;

- (id)initInViewController:(UIViewController<FTActionSheetDelegate> *)viewController;
- (void)show;
- (void)hide;

- (IBAction)btnGesturePressed:(UIButton *)sender;
- (IBAction)btnButtonPressed:(UIButton *)sender;

@end
