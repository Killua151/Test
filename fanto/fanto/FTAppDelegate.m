//
//  FTAppDelegate.m
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTLoginViewController.h"

@implementation FTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  
  UINavigationController *navigationVC =
  [[UINavigationController alloc] initWithRootViewController:[FTLoginViewController new]];
  self.window.rootViewController = navigationVC;
  [self.window makeKeyAndVisible];
  
  // Whenever a person opens the app, check for a cached session
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    [FBSession
     openActiveSessionWithReadPermissions:@[@"public_profile"]
     allowLoginUI:NO
     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
       [self sessionStateChanged:session state:state error:error];
     }];
  }
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
  if (!error && state == FBSessionStateOpen) {
    // Login
    return;
  }
  
  if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
    // Logout
  }
  
  // Handle errors
  if (error) {
    // If the error requires people using an app to make an action outside of the app in order to recover
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
      DLog(@"%@", [FBErrorUtility userMessageForError:error]);
    } else {
      // If the user cancelled login, do nothing
      if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        DLog(@"User cancelled login");
      } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
        DLog(@"Your current session is no longer valid. Please log in again.");
      } else {
        //Get more error information from the error
        NSDictionary *errorInformation = error.userInfo[@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"];
        DLog(@"%@",
             [NSString stringWithFormat:
              @"Please retry.\nIf the problem persists contact us and mention this error code: %@",
              errorInformation[@"message"]]);
      }
    }

    [FBSession.activeSession closeAndClearTokenInformation];
  }
}

@end
