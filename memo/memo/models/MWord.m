//
//  MWord.m
//  memo
//
//  Created by Ethan Nguyen on 10/20/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MWord.h"

@implementation MWord

+ (instancetype)sharedWordsDictionary {
  static MWord *_sharedWordsDictionary = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedWordsDictionary = [MWord new];
  });
  
  return _sharedWordsDictionary;
}

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

@end
