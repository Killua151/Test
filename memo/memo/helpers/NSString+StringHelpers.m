//
//  NSString+StringHelpers.m
//  fanto
//
//  Created by Ethan Nguyen on 10/4/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "NSString+StringHelpers.h"

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

- (NSString *)asciiNormalizedString {
  NSString *stringToNormalize = [[self class] normalizedString:self];
  
  NSString *standard = [stringToNormalize stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
  standard = [standard stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
  NSData *decode = [standard dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *asciiString = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
  
  return asciiString;
}

- (NSString *)stringByRemovingAllNonLetterCharacters {
  NSString *resultString = [self lowercaseString];
  NSMutableArray *components = [NSMutableArray arrayWithArray:[resultString componentsSeparatedByCharactersInSet:
                                                               [[NSCharacterSet letterCharacterSet] invertedSet]]];
  
  [components removeObject:@""];
  resultString = [components componentsJoinedByString:@" "];
  
  return resultString;
}

- (NSString *)stringByRemovingAllNonDigitCharacters {
  NSString *resultString = [self lowercaseString];
  NSMutableArray *components = [NSMutableArray arrayWithArray:[resultString componentsSeparatedByCharactersInSet:
                                                               [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]];
  
  [components removeObject:@""];
  resultString = [components componentsJoinedByString:@" "];
  
  return resultString;
}

- (NSString *)localizedStringWithLanguage:(NSString *)language {
  return self;
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
  DiffMatchPatch *dfp = [DiffMatchPatch new];
  
  NSArray *diffs = [dfp diff_mainOfOldString:otherString andNewString:self];
  
  for (Diff *diff in diffs) {
    if (diff.operation == DIFF_DELETE)
      return YES;
  }
  
  return YES;
}

@end
