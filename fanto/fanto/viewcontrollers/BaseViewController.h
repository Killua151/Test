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

+ (UIViewController *)navigationController;

- (void)gestureLayerDidEnterEdittingMode;
- (void)gestureLayerDidTap;
- (void)reloadContents;
- (void)animateSlideView:(BOOL)isSlidingUp withDistance:(CGFloat)distance;
- (void)beforeGoBack;
- (void)afterGoBack;

- (void)customNavBarBgWithColor:(UIColor *)color;
- (void)customNavBarBgWithImageName:(NSString *)imageName;
- (void)customNavBarBgWithImage:(UIImage *)image;
- (void)customBackButton;
- (void)customTitleWithText:(NSString*)title color:(UIColor *)titleColor;
- (void)customTitleLogo;
- (void)customBarButtonWithImage:(NSString*)imageName
                           title:(NSString*)title
                          target:(id)target
                          action:(SEL)action
                        distance:(CGFloat)distance;

@end