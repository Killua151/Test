//
//  UIColor+ColorHelpers.m
//  fanto
//
//  Created by Ethan Nguyen on 10/1/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "UIColor+ColorHelpers.h"

@implementation UIColor (ColorHelpers)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
  NSString *hexStr = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
  
  NSScanner *scanner = [NSScanner scannerWithString:hexStr];
  [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
  
  unsigned hexValue;
  
  if (![scanner scanHexInt:&hexValue])
    return nil;
  
  return [UIColor colorWithHexValue:hexValue];
}

+ (UIColor *)colorWithHexValue:(NSInteger)hexValue {
  unsigned char r, g, b;
  
  b = hexValue & 0xFF;
  g = (hexValue >> 8) & 0xFF;
  r = (hexValue >> 16) & 0xFF;
  
  return UIColorFromRGB(r, g, b);
}

@end
