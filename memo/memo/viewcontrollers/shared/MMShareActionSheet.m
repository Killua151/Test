//
//  FTActionSheet.m
//  fanto
//
//  Created by Ethan Nguyen on 9/23/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMShareActionSheet.h"

@interface MMShareActionSheet ()

- (void)setupViews;

@end

@implementation MMShareActionSheet

- (id)initInViewController:(UIViewController<FTActionSheetDelegate> *)viewController {
  if (self = [super init]) {
    LoadXibWithSameClass();
    
    CGRect frame = self.frame;
    frame.size.height = viewController.view.frame.size.height;
    self.frame = frame;
    
    _delegate = viewController;
    [viewController.view addSubview:self];
    [self setupViews];
  }
  
  return self;
}

- (IBAction)btnGesturePressed:(UIButton *)sender {
  [self hide];
}

- (IBAction)btnButtonPressed:(UIButton *)sender {
  [self hide];
  
  if ([_delegate respondsToSelector:@selector(actionSheetDidSelectAtIndex:)])
    [_delegate actionSheetDidSelectAtIndex:sender.tag];
}

- (void)show {
  [self animateShowsShareViewUp:YES];
}

- (void)hide {
  [self animateShowsShareViewUp:NO];
}

#pragma mark - Private methods
- (void)setupViews {
  CGRect frame = _vMain.frame;
  frame.origin.y = self.frame.size.height;
  _vMain.frame = frame;
  
  _btnFacebook.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnGoogle.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnTwitter.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  
  self.userInteractionEnabled = NO;
}

- (void)animateShowsShareViewUp:(BOOL)isUp {
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vBackground.alpha = isUp ? 0.5 : 0;
     
     CGRect frame = _vMain.frame;
     frame.origin.y = isUp ? 0 : self.frame.size.height;
     _vMain.frame = frame;
   }
   completion:^(BOOL finished) {
     self.userInteractionEnabled = isUp;
   }];
}

@end
