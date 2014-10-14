//
//  NSError+ErrorHelpers.h
//  memo
//
//  Created by Ethan Nguyen on 10/14/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ErrorHelpers)

- (NSString *)errorMessage;
- (NSInteger)errorCode;

@end
