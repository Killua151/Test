//
//  MABaseViewController.m
//  medicine-alert
//
//  Created by Ethan Nguyen on 6/27/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import "BaseViewController.h"
#import "MMAppDelegate.h"
#import "MMShareViewController.h"
#import "MMAdsBannerCell.h"
#import "MCrossSale.h"
#import "MAdsConfig.h"
#import "MLatestVersion.h"

@interface BaseViewController ()

- (void)setupGestureLayer;
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recognizer;

@end

@implementation BaseViewController

+ (UINavigationController *)navigationController {
  BaseViewController *viewController = [[self class] new];
  return [viewController parentNavigationController];
}

- (UINavigationController *)parentNavigationController {
  if (self.navigationController != nil)
    return self.navigationController;
  
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
  return navController;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupGestureLayer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.screenName = [NSString stringWithFormat:@"iOS screen %@", NSStringFromClass([self class])];
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion {
  if (self.navigationController != nil)
    [self.navigationController presentViewController:viewController animated:flag completion:completion];
  else
    [super presentViewController:viewController animated:flag completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
  if (self.navigationController != nil)
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
  else
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)transitToViewController:(UIViewController *)viewController completion:(void (^)(UIViewController *))handler {
  viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  
  [[self mainViewController] presentViewController:viewController animated:YES completion:^{
    MMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = viewController;
    
    if (handler != NULL)
      handler(viewController);
  }];
}

- (void)presentShareViewControllerWithDefaultOption:(ShareOption)shareOption {
  MMShareViewController *shareVC = [[MMShareViewController alloc] initWithDefaultOption:shareOption];
  [self presentViewController:[shareVC parentNavigationController] animated:YES completion:NULL];
}

- (UIViewController *)mainViewController {
  if (self.navigationController != nil)
    return self.navigationController;
  
  return self;
}

- (UIView *)mainView {
  UIViewController *mainViewController = [self mainViewController];
  
  if ([mainViewController respondsToSelector:@selector(view)])
    return [self mainViewController].view;
  
  return nil;
}

- (void)gestureLayerDidEnterEditingMode {
  _vGestureLayer.hidden = NO;
}

- (void)gestureLayerDidTap {
  // Implement in child class
}

- (void)reloadContents {
  // Implement in child class
}

- (void)animateSlideViewUp:(BOOL)isSlidingUp withDistance:(CGFloat)distance {
  CGFloat iOS7TopEdge = self.navigationController ? (self.navigationController.navigationBar.translucent ? 0 : 64) : 0;
  CGFloat topEdgeDelta = DeviceSystemIsOS7() ? iOS7TopEdge : 0;
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     CGRect frame = self.view.frame;
     frame.origin.y = isSlidingUp ? -distance+topEdgeDelta : topEdgeDelta;
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

- (void)customNavBarBgWithColor:(UIColor *)color {
  if (self.navigationController == nil)
    return;
  
  if (color == [UIColor clearColor] || color == nil) {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
  } else {
    self.navigationController.navigationBar.translucent = NO;
    
    if (!DeviceSystemIsOS7()) {
      [self customNavBarBgWithImage:[UIImage imageFromColor:color]];
      return;
    }
    
    self.navigationController.view.backgroundColor = color;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
      self.navigationController.navigationBar.barTintColor = color;
  }
}

- (void)customNavBarBgWithImageName:(NSString *)imageName {
  [self customNavBarBgWithImage:[UIImage imageNamed:@"img-navbar-bg.png"]];
}

- (void)customNavBarBgWithImage:(UIImage *)image {
  if (self.navigationController == nil)
    return;
  
  [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)customBackButtonWithSuffix:(NSString *)suffix {
  if (self.navigationController == nil)
    return;
  
  NSString *imageName = @"btn-navbar-back.png";
  
  if (suffix != nil && [suffix isKindOfClass:[NSString class]])
    imageName = [NSString stringWithFormat:@"btn-navbar-back_%@.png", suffix];
  
  UIImage *btnBackBg = [UIImage imageNamed:imageName];
  
  UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
  btnBack.frame = CGRectMake(0, 0, 50, 44);
  [btnBack setImage:btnBackBg forState:UIControlStateNormal];
  [btnBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
  
  MMAllowsTouchOutsideView *view = [[MMAllowsTouchOutsideView alloc] initWithFrame:btnBack.frame];
  view.bounds = CGRectOffset(view.bounds, DeviceSystemIsOS7() ? 16 : 10, 0);
  [view addSubview:btnBack];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (UIBarButtonItem *)customBarButtonWithImage:(NSString *)imageName
                                        title:(NSString *)title
                                        color:(UIColor *)titleColor
                                       target:(id)target
                                       action:(SEL)action
                                     distance:(CGFloat)distance {
  if (self.navigationController == nil || (imageName == nil && title == nil))
    return nil;
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  
  CGSize buttonSize = CGSizeMake(0, self.navigationController.navigationBar.frame.size.height);
  
  if (imageName != nil) {
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    buttonSize.width += image.size.width;
  }
  
  if (title != nil) {
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    CGSize titleSize = [button.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, button.titleLabel.frame.size.height)];
    buttonSize.width += titleSize.width;
  }
  
  // In case of both image name & title given, stretch the button to make room betwen 2
  if (imageName != nil && title != nil) {
    buttonSize.width += 7;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -7);
  }
  
  button.frame = (CGRect){CGPointZero, buttonSize};
  
  if (target != nil && action != nil)
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  else
    button.userInteractionEnabled = NO;
  
  if (distance < 0)
    distance = -5;
  else
    distance = 5;
  
  MMAllowsTouchOutsideView *view = [[MMAllowsTouchOutsideView alloc] initWithFrame:button.frame];
  view.bounds = CGRectOffset(view.bounds, DeviceSystemIsOS7() ? distance : -distance, 0);
  [view addSubview:button];
  
  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:view];
  
  if (distance < 0)
    self.navigationItem.rightBarButtonItem = barButton;
  else
    self.navigationItem.leftBarButtonItem = barButton;
  
  return barButton;
}

- (void)customTitleWithText:(NSString*)title color:(UIColor *)titleColor {
  if (self.navigationController == nil)
    return;
  
  UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
  lblTitle.backgroundColor = [UIColor clearColor];
  lblTitle.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  lblTitle.text = title;
  lblTitle.textColor = titleColor;
  lblTitle.minimumScaleFactor = 12.0/lblTitle.font.pointSize;
  lblTitle.adjustsFontSizeToFitWidth = YES;
  lblTitle.numberOfLines = 1;
  [lblTitle sizeToFit];
  
  CGRect frame = lblTitle.frame;
  frame.size.width = MIN(frame.size.width, 165);
  lblTitle.frame = frame;
  
  UIView *lblTitleView = [[UIView alloc] initWithFrame:lblTitle.frame];
  [lblTitleView addSubview:lblTitle];
  
  self.navigationItem.titleView = lblTitleView;
}

- (void)customTitleLogo {
  if (self.navigationController == nil)
    return;
  
  UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 29)];
  imgLogo.image = [UIImage imageNamed:@"img-navbar-logo_title"];
  
  UIView *imgLogoView = [[UIView alloc] initWithFrame:imgLogo.frame];
  [imgLogoView addSubview:imgLogo];
  
  self.navigationItem.titleView = imgLogoView;
}

- (void)checkLatestVersion {
  [[MMServerHelper railsApiHelper]
   getLatestVersion:^{
     MLatestVersion *latestVersion = [MLatestVersion version];
     
     [self setupAppVersion];
     
     if (latestVersion == nil || latestVersion.is_latest)
       return;
     
     if (latestVersion.allowed) {
       [UIAlertView
        showWithTitle:MMLocalizedString(@"New version available")
        message:latestVersion.message
        cancelButtonTitle:MMLocalizedString(@"Cancel")
        otherButtonTitles:@[MMLocalizedString(@"Update")]
        callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
          if (buttonIndex == 0)
            return;
          
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:latestVersion.market_url]];
        }];
       return;
     }
     
     [UIAlertView
      showWithTitle:MMLocalizedString(@"New version available")
      message:latestVersion.message
      cancelButtonTitle:nil
      otherButtonTitles:@[MMLocalizedString(@"Update")]
      callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:latestVersion.market_url]];
        exit(0);
      }];
   }];
}

- (void)setupAppVersion {
  _lblAppVersion.font = [UIFont fontWithName:@"ClearSans" size:14];
  _lblAppVersion.text = [NSString stringWithFormat:@"v%@", CurrentBuildVersion()];
  _lblAppVersion.superview.hidden = ![MLatestVersion version].is_beta;
}

- (void)checkToDisplayAds {
  _adsConfigsData = [MCrossSale sharedModel].runningAds[NSStringFromClass([self class])];
  
  if (_adsConfigsData != nil && [_adsConfigsData isKindOfClass:[NSDictionary class]])
    [self displayCrossSaleAds];
}

- (void)displayCrossSaleAds {
  // Implement in child class
}

- (UITableViewCell *)adsBannerCellForConfig:(id)adsConfig inTableView:(UITableView *)tableView {
  if (adsConfig == nil || ![adsConfig isKindOfClass:[MAdsConfig class]])
    return nil;
  
  MMAdsBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MMAdsBannerCell class])];
  
  if (cell == nil) {
    cell = [MMAdsBannerCell new];
    cell.delegate = self;
  }
  
  [cell updateCellWithData:adsConfig];
  
  return cell;
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

- (void)dismissViewController {
  [[self mainViewController] dismissViewControllerAnimated:YES completion:NULL];
}

@end
