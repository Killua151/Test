//
//  MWord.m
//  memo
//
//  Created by Ethan Nguyen on 10/20/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MWord.h"

@implementation MWord

- (void)setupDictionary:(id)dictionaryData {
  if (_dictionary == nil)
    _dictionary = [NSMutableDictionary new];
  
  [_dictionary removeAllObjects];
  
  if (dictionaryData == nil)
    return;
  
  NSMutableArray *soundsArr = [NSMutableArray array];
  
  if ([dictionaryData isKindOfClass:[NSDictionary class]])
    [dictionaryData enumerateKeysAndObjectsUsingBlock:^(NSString *text, NSDictionary *wordData, BOOL *stop) {
      MWord *word = [MWord modelFromDict:wordData];
      _dictionary[text] = word;
      [soundsArr addObject:word.sound];
    }];
  else if ([dictionaryData isKindOfClass:[NSArray class]])
    for (NSDictionary *wordData in dictionaryData) {
      MWord *word = [MWord modelFromDict:wordData];
      _dictionary[word.text] = word;
      [soundsArr addObject:word.sound];
    }
  
  [Utils preDownloadAudioFromUrls:soundsArr];
}

- (MWord *)wordModelForText:(NSString *)text {
  MWord *word = _dictionary[text];
  
  if (word == nil)
    word = _dictionary[[text lowercaseString]];
  
  return word;
}

@end
