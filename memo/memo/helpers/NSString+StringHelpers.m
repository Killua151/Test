//
//  NSString+StringHelpers.m
//  fanto
//
//  Created by Ethan Nguyen on 10/4/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "NSString+StringHelpers.h"

typedef enum TyposCheckingResultEnum {
  kTyposCheckingEqualString = -1,
  kTyposCheckingIsTypo = 0,
  kTyposCheckingDifferent
} TyposCheckingResult;

@interface NSString (StringHelpers_Private)

- (TyposCheckingResult)checkTypoOnWord:(NSString *)inputWord withDiffMatchPatch:(DiffMatchPatch *)dmp;

@end

@implementation NSString (StringHelpers)

+ (BOOL)floatValueIsInteger:(CGFloat)value {
  NSString *valueString = [NSString stringWithFormat:@"%.2f", value];
  
  return [[valueString componentsSeparatedByString:@"."][1] isEqualToString:@"00"];
}

+ (NSString *)stringForFloatValue:(CGFloat)value shouldDisplayZero:(BOOL)displayZero {
  if (value == 0.0 && !displayZero)
    return @"";
  
  if ([[self class] floatValueIsInteger:value])
    return [NSString stringWithFormat:@"%d", (int)value];
  
  return [NSString stringWithFormat:@"%.2f", value];
}

+ (NSString *)normalizedString:(NSString *)string {
  return [[self class] normalizedString:string withPlaceholder:@""];
}

+ (NSString *)normalizedString:(NSString *)string withPlaceholder:(NSString *)placeholder {
  return string == nil || ![string isKindOfClass:[NSString class]] ? placeholder : string;
}

- (BOOL)validateEmail {
  BOOL stricterFilter = YES;
  
  NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
  NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  
  return [predicate evaluateWithObject:self];
}

- (BOOL)validateAlphaNumeric {
  NSString *myRegex = @"[A-Z0-9a-z_]*";
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
  
  return [predicate evaluateWithObject:self];
}

- (BOOL)validateBlank {
  NSString *filtedString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
  filtedString = [filtedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  
  return ![filtedString isEqualToString:@""];
}

- (NSString *)asciiNormalizedString {
  NSString *stringToNormalize = [[self class] normalizedString:self];
  
  NSString *standard = [stringToNormalize stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
  standard = [standard stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
  NSData *decode = [standard dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *asciiString = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
  
  return asciiString;
}

- (NSString *)stringByRemovingAllNonLetterCharacters {
  NSArray *components = [[self lowercaseString] componentsSeperatedByNonLetterCharacters];
  return [components componentsJoinedByString:@" "];
}

- (NSArray *)componentsSeperatedByNonLetterCharacters {
  NSString *resultString = [self lowercaseString];
  NSMutableArray *components = [NSMutableArray arrayWithArray:[resultString componentsSeparatedByCharactersInSet:
                                                               [[NSCharacterSet letterCharacterSet] invertedSet]]];
  
  [components removeObject:@""];
  return components;
}

- (NSString *)stringByRemovingAllNonDigitCharacters {
  NSArray *components = [[self lowercaseString] componentsSeperatedByNonDigitCharacters];
  return [components componentsJoinedByString:@" "];
}

- (NSArray *)componentsSeperatedByNonDigitCharacters {
  NSMutableArray *components = [NSMutableArray arrayWithArray:[self componentsSeparatedByCharactersInSet:
                                                               [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]];
  
  [components removeObject:@""];
  return components;
}

- (NSString *)localizedStringForLanguage:(NSString *)language {  
  return NSLocalizedString(self, nil);
}

- (BOOL)isAcceptedSimilarToOneOfStrings:(NSArray *)otherStrings {
  if (otherStrings == nil || ![otherStrings isKindOfClass:[NSArray class]])
    return NO;
  
  return YES;
  
  for (NSString *otherString in otherStrings)
    if ([self isAcceptedSimilarToString:otherString])
      return YES;
  
  return NO;
}

- (BOOL)isAcceptedSimilarToString:(NSString *)otherString {
  NSArray *selfComponents = [self componentsSeperatedByNonLetterCharacters];
  NSArray *otherComponents = [otherString componentsSeperatedByNonLetterCharacters];
  
  if ([selfComponents count] != [otherComponents count])
    return NO;
  
  DiffMatchPatch *dmp = [DiffMatchPatch new];
  
  [selfComponents enumerateObjectsUsingBlock:^(NSString *selfComponent, NSUInteger index, BOOL *stop) {
    NSArray *diffs = [dmp diff_mainOfOldString:otherComponents[index] andNewString:selfComponent];
    
    if ([diffs count] == 1 && [diffs[0] operation] == DIFF_EQUAL)
      return;
    
    for (Diff *diff in diffs) {
      DLog(@"%d %@", diff.operation, diff.text);
    }
  }];
  
  for (NSInteger i = 0; i < [selfComponents count]; i++) {
  }
  
  return YES;
}

- (NSInteger)wordsCount {
  return [[self componentsSeperatedByNonLetterCharacters] count];
}

- (NSArray *)checkTyposOnString:(NSString *)inputString {
  NSArray *selfWords = [[self lowercaseString] componentsSeperatedByNonLetterCharacters];
  NSArray *inputWords = [[inputString lowercaseString] componentsSeperatedByNonLetterCharacters];

  // Reduce cost of typos checking operation,
  // Ideal condition: the inputs should be at the same amount of words
//  if ([selfComponents count] != [inputComponents count])
//    return @[[NSValue valueWithRange:NSMakeRange(0, self.length)]];
  
  __block NSMutableArray *typos = [NSMutableArray array];
  
  DiffMatchPatch *dmp = [DiffMatchPatch new];
  
  [selfWords enumerateObjectsUsingBlock:^(NSString *selfWord, NSUInteger index, BOOL *stop) {
    NSString *inputWord = inputWords[index];
    TyposCheckingResult checkingResult = [selfWord checkTypoOnWord:inputWord withDiffMatchPatch:dmp];
    
    if (checkingResult == kTyposCheckingEqualString)
      return;
    
    if (checkingResult == kTyposCheckingDifferent) {
      typos = nil;
      *stop = YES;
      return;
    }
    
    [typos addObject:selfWord];
  }];
  
  if (typos == nil)
    return nil;
  
  NSMutableArray *ranges = [NSMutableArray array];
  
  for (NSString *typo in typos) {
    NSString *searchWord = [NSString stringWithFormat:@"\\b%@\\b", typo];
    NSRange typoRange = [self rangeOfString:searchWord options:NSRegularExpressionSearch | NSCaseInsensitiveSearch];
    
    if (typoRange.location != NSNotFound)
      [ranges addObject:[NSValue valueWithRange:typoRange]];
  }
  
  return ranges;
}

#pragma mark - StringHelpers_Private methods
- (TyposCheckingResult)checkTypoOnWord:(NSString *)inputWord withDiffMatchPatch:(DiffMatchPatch *)dmp {
  if ([self isEqualToString:inputWord])
    return kTyposCheckingEqualString;
  
  // V1.0: count EQUAL operations only
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operation = %d", DIFF_EQUAL];
//  NSArray *filtered = [diffs filteredArrayUsingPredicate:predicate];
//
//  NSInteger equalCounts = [filtered count];
//
//  // Incorrect word
//  if (equalCounts == 0) // && selfComponent.length != inputComponent.length)
//    return kTyposCheckingDifferent;
  
  // V1.1: count most continuous EQUAL characters
//  NSInteger maxEqualCharsCount = 0;
//  
//  for (Diff *diff in diffs) {
//    if (diff.operation != DIFF_EQUAL)
//      continue;
//    
//    if (maxEqualCharsCount < diff.text.length)
//      maxEqualCharsCount = diff.text.length;
//  }
//  
//  if (((CGFloat)maxEqualCharsCount)/self.length < 0.7)
//    return kTyposCheckingDifferent;
  
  // V1.2: check different characters by self word's length
  
  // Compare ascii-converted words
  if ([[self asciiNormalizedString] isEqualToString:[inputWord asciiNormalizedString]])
    return kTyposCheckingIsTypo;
  
  // If word is single-character: input word is a different word -> incorrect
  if (self.length <= 1)
    return kTyposCheckingDifferent;
  
  NSArray *diffs = [dmp diff_mainOfOldString:inputWord andNewString:self];
  
  NSInteger totalDifferentCharsCount = self.length;
  
  for (Diff *diff in diffs)
    if (diff.operation == DIFF_EQUAL)
      totalDifferentCharsCount -= diff.text.length;
  
  if ((self.length >= 2 && self.length <= 4 && totalDifferentCharsCount > 1) ||
      (self.length > 4 && totalDifferentCharsCount > 2))
    return kTyposCheckingDifferent;
  
  return kTyposCheckingIsTypo;
}

@end
