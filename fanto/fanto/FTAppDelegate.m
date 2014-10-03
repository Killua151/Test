//
//  FTAppDelegate.m
//  fanto
//
//  Created by Ethan Nguyen on 9/10/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTHomeViewController.h"
#import "FTSkillsListViewController.h"
#import <Crashlytics/Crashlytics.h>
#import <GooglePlus/GooglePlus.h>
#import "iSpeechSDK.h"
#import <Mixpanel/Mixpanel.h>
#import "MUser.h"
#import "MBaseQuestion.h"

@interface FTAppDelegate () <UIAlertViewDelegate>

- (void)preSettingsWithLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)setupRootViewController;
- (void)test;

@end

@implementation FTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self preSettingsWithLaunchingWithOptions:launchOptions];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self setupRootViewController];
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
  BOOL facebookHandler = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
  BOOL googleHandler = [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
  
  return facebookHandler || googleHandler;
}

- (BOOL)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
  // Logged in
  if (error == nil && state == FBSessionStateOpen)
    return YES;
  
  // Logout current user
  if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
  }
  
  // Handle errors
  if (error != nil) {
    NSString *message = nil;
    
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
      message = [FBErrorUtility userMessageForError:error];
    else {
      if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
        message = nil;
      else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
        message = @"Your current session is no longer valid. Please log in again.";
      else
        message = [NSString stringWithFormat:
                             @"Please retry.\nIf the problem persists contact us and mention this error code: %@",
                             error.userInfo[@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"][@"message"]];
    }
    
    [Utils showAlertWithTitle:@"Error" andMessage:message];
    [[FBSession activeSession] closeAndClearTokenInformation];
  }
  
  return NO;
}

- (void)setupRootViewController {
  if ([MUser currentUser] == nil)
    self.window.rootViewController = [FTHomeViewController navigationController];
  else
    self.window.rootViewController = [FTSkillsListViewController navigationController];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [MUser logOutCurrentUser];
  [self setupRootViewController];
}

#pragma mark Private methods
- (void)preSettingsWithLaunchingWithOptions:(NSDictionary *)launchOptions {
#if !TARGET_IPHONE_SIMULATOR
  [iSpeechSDK sharedSDK].APIKey = kiSpeechApiKey;
#endif
  [Crashlytics startWithAPIKey:kCrashlyticsApiKey];
  [Mixpanel sharedInstanceWithToken:kMixPanelToken launchOptions:launchOptions];
  
#if kTestLogin
  [MUser logOutCurrentUser];
#endif
  [MUser loadCurrentUserFromUserDef];
  
#if kTestCompactTranslation
  [NSString testCompactTranslations];
#endif
  
  [self test];
}

- (void)test {
  DLog(@"%@ %@", [MUser currentUser]._id, [MUser currentUser].auth_token);
}

@end
