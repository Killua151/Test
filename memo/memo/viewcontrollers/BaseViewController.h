//
//  MABaseViewController.h
//  medicine-alert
//
//  Created by Ethan Nguyen on 6/27/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import <GAITrackedViewController.h>

@interface BaseViewController : GAITrackedViewController {
  IBOutlet MMAllowsTouchUnderneathView *_vGestureLayer;
}

+ (UINavigationController *)navigationController;
- (UINavigationController *)parentNavigationController;

- (void)transitToViewController:(UIViewController *)viewController
                     completion:(void(^)(UIViewController *viewController))handler;
- (void)presentShareViewControllerWithDefaultOption:(ShareOption)shareOption;
- (UIViewController *)mainViewController;
- (UIView *)mainView;

- (void)gestureLayerDidEnterEditingMode;
- (void)gestureLayerDidTap;
- (void)reloadContents;
- (void)animateSlideViewUp:(BOOL)isSlidingUp withDistance:(CGFloat)distance;

- (void)goBack;
- (void)dismissViewController;
- (void)beforeGoBack;
- (void)afterGoBack;

- (void)customNavBarBgWithColor:(UIColor *)color;
- (void)customNavBarBgWithImageName:(NSString *)imageName;
- (void)customNavBarBgWithImage:(UIImage *)image;
- (void)customBackButtonWithSuffix:(NSString *)suffix;
- (void)customTitleWithText:(NSString*)title color:(UIColor *)titleColor;
- (void)customTitleLogo;
- (UIBarButtonItem *)customBarButtonWithImage:(NSString*)imageName
                                        title:(NSString*)title
                                        color:(UIColor *)titleColor
                                       target:(id)target
                                       action:(SEL)action
                                     distance:(CGFloat)distance;

@end