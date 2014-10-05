//
//  MMAppDelegate.h
//  memo
//
//  Created by Ethan Nguyen on 10/5/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void)setupRootViewController;

@end
