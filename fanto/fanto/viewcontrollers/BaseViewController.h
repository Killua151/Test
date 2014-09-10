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

- (void)gestureLayerDidEnterEdittingMode;
- (void)gestureLayerDidTap;
- (void)reloadContents;
- (void)animateSlideView:(BOOL)isSlidingUp withDistance:(CGFloat)distance;
- (void)goBack;

- (void)customNavigationBackgroundWithColor:(UIColor *)color;
- (void)customNavigationBackgroundWithImage:(NSString *)imageName;
- (void)customBackButton;
- (void)customTitleWithText:(NSString*)title;
- (void)customTitleLogo;
- (void)customBarButtonWithImage:(NSString*)imageName
                           title:(NSString*)title
                          target:(id)target
                          action:(SEL)action
                        distance:(CGFloat)distance;
- (void)resignCurrentFirstResponder;

@end