//
//  MABaseViewController.m
//  medicine-alert
//
//  Created by Ethan Nguyen on 6/27/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import "BaseViewController.h"

@interface MABaseViewController ()

- (void)setupGestureLayer;

@end

@implementation MABaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupGestureLayer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = topBarOffset * -1;
    self.view.bounds = viewBounds;
  }
}

- (void)gestureLayerDidEnterEdittingMode {
  _vGestureLayer.hidden = NO;
}

- (void)gestureLayerDidTap {
  // Implement in child class
}

- (void)reloadContents {
  // Implement in child class
}

- (void)animateSlideView:(BOOL)isSlidingUp withDistance:(CGFloat)distance {
  [UIView
   animateWithDuration:0.25
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGRect frame = self.view.frame;
     frame.origin.y = isSlidingUp ? -distance+64 : 64;
     self.view.frame = frame;
   }
   completion:^(BOOL finished) {
   }];
}

- (void)customNavigationBackgroundWithColor:(UIColor *)color {
  if (self.navigationController == nil)
    return;
  
  [self.navigationController.navigationBar setBarTintColor:color];
  [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)customNavigationBackgroundWithImage:(NSString *)imageName {
  if (self.navigationController == nil)
    return;
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img-navbar-bg.png"]
                                                forBarMetrics:UIBarMetricsDefault];
}

- (void)customBackButton {
  if (!self.navigationController)
    return;
  
  UIImage *btnBackBg = [UIImage imageNamed:@"btn-navbar-back"];
  
  UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
  btnBack.frame = CGRectMake(0, 0, 50, 44);
  [btnBack setImage:btnBackBg forState:UIControlStateNormal];
  [btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
  
  UIView *btnBackView = [[UIView alloc] initWithFrame:btnBack.frame];
  btnBackView.bounds = CGRectOffset(btnBackView.bounds, 16, 0);
  [btnBackView addSubview:btnBack];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBackView];
}

- (void)customBarButtonWithImage:(NSString *)imageName
                           title:(NSString *)title
                          target:(id)target
                          action:(SEL)action
                        distance:(CGFloat)distance {
  if (!self.navigationController)
    return;
  
  UIImage *image = [UIImage imageNamed:imageName];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  
  if (distance > 0)
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  else
    button.frame = CGRectMake(-2, -1, image.size.width, image.size.height);
  
  [button setBackgroundImage:image forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [button setTitleEdgeInsets:UIEdgeInsetsMake(6, 0, 0, 0)];
  [button setTitleColor:[UIColor colorWithRed:55.0/255 green:22.0/255 blue:0 alpha:1]
               forState:UIControlStateNormal];
  
  if (title)
    [button setTitle:title forState:UIControlStateNormal];
  
  [button addTarget:target
             action:action
   forControlEvents:UIControlEventTouchUpInside];
  
  UIView *view = [[UIView alloc] initWithFrame:button.frame];
  view.bounds = CGRectOffset(view.bounds, distance, 0);
  [view addSubview:button];
  
  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:view];
  
  if (distance > 0)
    self.navigationItem.rightBarButtonItem = barButton;
  else
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)customTitleWithText:(NSString*)title {
  if (!self.navigationController)
    return;
  
  UILabel *lblTitle = [UILabel new];
  lblTitle.backgroundColor = [UIColor clearColor];
  lblTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  lblTitle.text = title;
  lblTitle.textColor = [UIColor whiteColor];
  [lblTitle sizeToFit];
  CGRect frame = lblTitle.frame;
  frame.origin.y = -3;
  lblTitle.frame = frame;
  UIView *lblTitleView = [[UIView alloc] initWithFrame:lblTitle.frame];
  [lblTitleView addSubview:lblTitle];
  
  self.navigationItem.titleView = lblTitleView;
}

- (void)customTitleLogo {
  if (!self.navigationController)
    return;
  
  UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:
                          CGRectMake(0, 0, 78, 29)];
  imgLogo.image = [UIImage imageNamed:@"img-navbar-logo_title"];
  
  UIView *imgLogoView = [[UIView alloc] initWithFrame:imgLogo.frame];
  [imgLogoView addSubview:imgLogo];
  
  self.navigationItem.titleView = imgLogoView;
}

- (void)goBack {
  if (self.navigationController)
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resignCurrentFirstResponder {
  
}

#pragma mark - Private methods
- (void)setupGestureLayer {
  _vGestureLayer.hidden = YES;
  
  UITapGestureRecognizer *tapGesture =
  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
  tapGesture.numberOfTouchesRequired = 1;
  tapGesture.numberOfTapsRequired = 1;
  
  [_vGestureLayer addGestureRecognizer:tapGesture];
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
  _vGestureLayer.hidden = YES;
  [self gestureLayerDidTap];
}

@end
