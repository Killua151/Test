//
//  MWord.m
//  memo
//
//  Created by Ethan Nguyen on 10/20/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MWord.h"

@implementation MWord

- (void)setupDictionary:(NSDictionary *)dictionary {
  if (_dictionary == nil)
    _dictionary = [NSMutableDictionary new];
  
  [_dictionary removeAllObjects];
  
  if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]])
    return;
  
  NSMutableArray *soundsArr = [NSMutableArray array];
  
  [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *text, NSDictionary *wordData, BOOL *stop) {
    MWord *word = [MWord modelFromDict:wordData];
    _dictionary[text] = word;
    [soundsArr addObject:word.sound];
  }];
  
  [Utils preDownloadAudioFromUrls:soundsArr];
}

@end
