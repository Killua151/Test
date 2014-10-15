//
//  NSString+CompactTranslation.m
//  fanto
//
//  Created by Ethan on 9/24/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "NSString+CompactTranslation.h"
#import "RegExCategories.h"

@interface NSString (CompactTranslation_Private)

+ (NSArray *)tokenizedCompactTranslation:(NSString *)translation;
+ (NSArray *)expandCompactTranslation:(NSArray *)tokensGroup;
+ (NSArray *)normalizeSentences:(NSArray *)sentences;

@end

@implementation NSString (CompactTranslation)

+ (NSArray *)fullSentencesFromTokensGroup:(NSArray *)tokensGroup {
  NSArray *sentences = [[self class] expandCompactTranslation:tokensGroup];
  return [[self class] normalizeSentences:sentences];
}

- (NSArray *)fullSentencesFromCompactTranslations {
  NSArray *tokens = [[self class] tokenizedCompactTranslation:self];
  NSArray *sentences = [[self class] expandCompactTranslation:tokens];
  return [[self class] normalizeSentences:sentences];
}

+ (void)testCompactTranslations {
  NSArray *compactTranslations =
  @[
    @"[Những/Các] đất nước khác nhau có [những/các] [nền/] văn hóa khác nhau.",
    @"Các đất nước khác nhau có các nền văn hóa khác nhau.",
    @"Mùa hè [thì/là] [dành/] cho [tuổi trẻ/thanh niên/thanh thiếu niên].",
    @"[Những người bạn/Các người bạn/Các bạn/Chúng bạn/Bạn bè/Các bạn bè/Những bạn bè] [của/] tôi [đến/tới] từ [những/các/nhiều] nền văn hóa khác [nhau/]."
    ];
  
  for (NSString *compactTranslation in compactTranslations) {
    NSArray *sentences = [compactTranslation fullSentencesFromCompactTranslations];
    
    DLog(@"\n\nCompact translation: %@\n====>\nFull sentences: %@",
         compactTranslation,
         [sentences componentsJoinedByString:@"\n"]);
  }
}

#pragma mark - Private methods
+ (NSArray *)tokenizedCompactTranslation:(NSString *)translation {
  NSArray *matches = [translation matches:RX(@"\\[[^\\]]*\\]")];
  NSMutableArray *matchedTokens = [NSMutableArray array];
  
  for (NSString *match in matches) {
    NSMutableArray *tokens = [NSMutableArray arrayWithArray:
                              [match componentsSeparatedByCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString:@"[]/"]]];
    [tokens removeObject:@""];
    
    if ([[match substringFromIndex:match.length-2] isEqualToString:@"/]"])
      [tokens addObject:@""];
    
    [matchedTokens addObject:tokens];
  }
  
  NSArray *splittedTokens = [translation split:RX(@"\\[[^\\]]*\\]")];
  
  NSMutableArray *tokens = [NSMutableArray array];
  
  for (NSInteger i = 0; i < [splittedTokens count]; i++) {
    [tokens addObject:splittedTokens[i]];
    
    if (i < [matchedTokens count])
      [tokens addObject:matchedTokens[i]];
  }
  
  return tokens;
}

+ (NSArray *)expandCompactTranslation:(NSArray *)tokensGroup {
  if (tokensGroup == nil || ![tokensGroup isKindOfClass:[NSArray class]])
    return nil;
  
  NSArray *tokens = [tokensGroup firstObject];
  
  if (![tokens isKindOfClass:[NSArray class]])
    tokens = @[tokens];
  
  if ([tokensGroup count] == 1)
    return tokens;
  
  NSArray *remainingTokens = [tokensGroup subarrayWithRange:NSMakeRange(1, [tokensGroup count]-1)];
  NSArray *nextTokens = [[self class] expandCompactTranslation:remainingTokens];
  
  NSMutableArray *results = [NSMutableArray array];
  
  for (NSString *token in tokens)
    for (NSString *nextToken in nextTokens)
      [results addObject:[token stringByAppendingString:nextToken]];
  
  return results;
}

+ (NSArray *)normalizeSentences:(NSArray *)sentences {
  NSMutableArray *normalizedSentences = [NSMutableArray array];
  
  for (NSString *sentence in sentences) {
    NSString *normalizedSentence = [sentence replace:RX(@"\\s+(\\s|\\.)") withDetailsBlock:^NSString *(RxMatch *match) {
      return [(RxMatch *)match.groups[1] value];
    }];
    
    [normalizedSentences addObject:normalizedSentence];
  }
  
  return normalizedSentences;
}

@end