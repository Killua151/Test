//
//  MABaseViewController.m
//  medicine-alert
//
//  Created by Ethan Nguyen on 6/27/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

- (void)setupGestureLayer;
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer;
- (void)goBack;

@end

@implementation BaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupGestureLayer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

//- (void)viewDidLayoutSubviews {
//  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
//    CGRect viewBounds = self.view.bounds;
//    CGFloat topBarOffset = self.topLayoutGuide.length;
//    viewBounds.origin.y = topBarOffset * -1;
//    self.view.bounds = viewBounds;
//  }
//}

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

- (void)beforeGoBack {
  // Implement in child class
}

- (void)afterGoBack {
  // Implement in child class
}

- (void)customNavigationBackgroundWithColor:(UIColor *)color {
  if (self.navigationController == nil)
    return;
  
  if (color == [UIColor clearColor] || color == nil) {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
  } else {
    self.navigationController.view.backgroundColor = color;
    self.navigationController.navigationBar.translucent = NO;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
      self.navigationController.navigationBar.barTintColor = color;
  }
}

- (void)customNavigationBackgroundWithImage:(NSString *)imageName {
  if (self.navigationController == nil)
    return;
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img-navbar-bg.png"]
                                                forBarMetrics:UIBarMetricsDefault];
}

- (void)customBackButton {
  if (self.navigationController != nil)
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
  if (self.navigationController != nil)
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
  if (self.navigationController == nil)
    return;
  
  UILabel *lblTitle = [UILabel new];
  lblTitle.backgroundColor = [UIColor clearColor];
  lblTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
  lblTitle.text = title;
  lblTitle.textColor = UIColorFromRGB(153, 153, 153);
  [lblTitle sizeToFit];
  CGRect frame = lblTitle.frame;
  frame.origin.y = -3;
  lblTitle.frame = frame;
  UIView *lblTitleView = [[UIView alloc] initWithFrame:lblTitle.frame];
  [lblTitleView addSubview:lblTitle];
  
  self.navigationItem.titleView = lblTitleView;
}

- (void)customTitleLogo {
  if (self.navigationController == nil)
    return;
  
  UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:
                          CGRectMake(0, 0, 78, 29)];
  imgLogo.image = [UIImage imageNamed:@"img-navbar-logo_title"];
  
  UIView *imgLogoView = [[UIView alloc] initWithFrame:imgLogo.frame];
  [imgLogoView addSubview:imgLogo];
  
  self.navigationItem.titleView = imgLogoView;
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

- (void)goBack {
  [self beforeGoBack];
  
  if (self.navigationController != nil)
    [self.navigationController popViewControllerAnimated:YES];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self afterGoBack];
  });
}

@end
