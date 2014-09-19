//
//  MABaseViewController.h
//  medicine-alert
//
//  Created by Ethan Nguyen on 6/27/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController {
  IBOutlet UIView *_vGestureLayer;
}

+ (UINavigationController *)navigationController;

- (void)gestureLayerDidEnterEdittingMode;
- (void)gestureLayerDidTap;
- (void)reloadContents;
- (void)animateSlideViewUp:(BOOL)isSlidingUp withDistance:(CGFloat)distance;
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