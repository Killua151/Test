//
//  UIColor+ColorHelpers.h
//  fanto
//
//  Created by Ethan Nguyen on 10/1/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(r, g, b) [UIColor colorWithRed:(CGFloat)r/255 green:(CGFloat)g/255 blue:(CGFloat)b/255 alpha:1]

@interface UIColor (ColorHelpers)

+ (UIColor *)colorWithHexValue:(NSInteger)hexValue;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
