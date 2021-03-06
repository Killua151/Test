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

- (BOOL)validateEmail;
- (BOOL)validateAlphaNumeric;
- (BOOL)validateBlank;

- (NSString *)asciiNormalizedString;
- (NSString *)stringByRemovingAllNonLetterCharacters;
- (NSArray *)componentsSeperatedByNonLetterCharacters;
- (NSString *)stringByRemovingAllNonDigitCharacters;
- (NSArray *)componentsSeperatedByNonDigitCharacters;
- (NSString *)normalizedScreenNameString;

- (NSString *)localizedStringForLanguage:(NSString *)language;

- (BOOL)isAcceptedSimilarToOneOfStrings:(NSArray *)otherStrings;
- (BOOL)isAcceptedSimilarToString:(NSString *)otherString;

- (NSInteger)wordsCount;
- (NSArray *)checkTyposOnString:(NSString *)inputString;

@end
