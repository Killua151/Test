//
//  NSString+StringHelpers.h
//  fanto
//
//  Created by Ethan Nguyen on 10/4/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringHelpers)

+ (BOOL)floatValueIsInteger:(CGFloat)value;
+ (NSString *)stringForFloatValue:(CGFloat)value shouldDisplayZero:(BOOL)displayZero;
+ (NSString *)normalizedString:(NSString *)string;
+ (NSString *)normalizedString:(NSString *)string withPlaceholder:(NSString *)placeholder;

- (NSString *)asciiNormalizedString;
- (NSString *)stringByRemovingAllNonLetterCharacters;
- (NSString *)stringByRemovingAllNonDigitCharacters;
- (NSString *)localizedStringForLanguage:(NSString *)language;

- (BOOL)isAcceptedSimilarToOneOfStrings:(NSArray *)otherStrings;
- (BOOL)isAcceptedSimilarToString:(NSString *)otherString;

@end
