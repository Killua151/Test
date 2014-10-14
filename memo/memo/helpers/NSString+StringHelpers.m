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

@end
