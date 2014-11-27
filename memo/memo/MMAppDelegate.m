//
//  MMAppDelegate.m
//  memo
//
//  Created by Ethan Nguyen on 10/5/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMAppDelegate.h"
#import "MMHomeViewController.h"
#import "MMSkillsListViewController.h"
#import "MMProfileViewController.h"
#import <Crashlytics/Crashlytics.h>
#import <GooglePlus/GooglePlus.h>
#import "iSpeechSDK.h"
#import <Mixpanel/Mixpanel.h>
#import <GAI.h>
#import "AppsFlyerTracker.h"
#import "MUser.h"
#import "MCrossSale.h"
#import "MBaseQuestion.h"

@interface MMAppDelegate ()

- (void)preSettingsForApp:(UIApplication *)application withLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)setupRootViewController;
- (void)handlePushNotification:(NSDictionary *)notificationData shouldShowAlert:(BOOL)shouldShowAlert;
- (void)test;

@end

@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self preSettingsForApp:application withLaunchingWithOptions:launchOptions];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self setupRootViewController];
  [self.window makeKeyAndVisible];
  
  // Whenever a person opens the app, check for a cached session
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    [FBSession
     openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
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
  application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSString *token = [UIDevice trimmedDeviceToken:deviceToken];
  
#if kTestPushNotification
  DLog(@"%@", token);
  [[MMServerHelper sharedHelper] registerDeviceTokenForAPNS];
#endif
  
  [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserDefApnsToken];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  if ([MUser currentUser]._id != nil)
    [[MMServerHelper apiHelper] updateApnsToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefApnsToken];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  if (userInfo == nil || ![userInfo isKindOfClass:[NSDictionary class]] ||
      userInfo[kParamAps] == nil || ![userInfo[kParamAps] isKindOfClass:[NSDictionary class]] ||
      userInfo[kParamAps][kParamAlert] == nil || ![userInfo[kParamAps][kParamAlert] isKindOfClass:[NSString class]])
    return;
  
  [UIAlertView
   showWithTitle:MMLocalizedString(@"Notification")
   message:userInfo[kParamAps][kParamAlert]
   callback:^(UIAlertView *alertView, NSInteger buttonIndex) {
     [self handlePushNotification:userInfo shouldShowAlert:NO];
   }];
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
    
    [UIAlertView showWithTitle:MMLocalizedString(@"Error") andMessage:message];
    [[FBSession activeSession] closeAndClearTokenInformation];
  }
  
  return NO;
}

- (void)setupRootViewController {
  if ([MUser currentUser] == nil)
    self.window.rootViewController = [MMHomeViewController navigationController];
  else {
    UINavigationController *navigation = [MMSkillsListViewController navigationController];
    MMSkillsListViewController *skillsListVC = navigation.viewControllers[0];
    self.window.rootViewController = navigation;
    [skillsListVC loadSkillsTree];
  }
}

- (void)openURL:(id)url {
  NSURL *urlObj = nil;
  
  if ([url isKindOfClass:[NSString class]])
    urlObj = [NSURL URLWithString:url];
  else if ([url isKindOfClass:[NSURL class]])
    urlObj = url;
  
  if (urlObj == nil || ![urlObj isKindOfClass:[NSURL class]] || [urlObj isEqual:[NSURL URLWithString:@"about:blank"]])
    return;
  
  KAWModalWebViewController *webVC = [KAWModalWebViewController new];
  webVC.view.backgroundColor = [UIColor whiteColor];
  webVC.url = urlObj;
  [[UIViewController currentActiveViewController] presentViewController:webVC animated:YES completion:NULL];
}

#pragma mark Private methods
- (void)preSettingsForApp:(UIApplication *)application withLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef __IPHONE_8_0
  // iOS 8 Notifications
  if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
    UIUserNotificationType notificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
  } else
    [application registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
#else
  // iOS < 8 Notifications
  [application registerForRemoteNotificationTypes:
   (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
#endif
  
#if !TARGET_IPHONE_SIMULATOR
  [iSpeechSDK sharedSDK].APIKey = kiSpeechApiKey;
#endif
  [Crashlytics startWithAPIKey:kCrashlyticsApiKey];
  [[LocalizationHelper sharedHelper] loadLocalizationForLanguage:PreferedAppLanguage()];
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];
  
  [Mixpanel sharedInstanceWithToken:kMixPanelToken launchOptions:launchOptions];
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  [GAI sharedInstance].dispatchInterval = 20;
  [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
  [[GAI sharedInstance] trackerWithTrackingId:kGAITrackingID];
  
  [AppsFlyerTracker sharedTracker].appleAppID = kItunesStoreID;
  [AppsFlyerTracker sharedTracker].appsFlyerDevKey = kAppsFlyerDevKey;
  [AppsFlyerTracker sharedTracker].isHTTPS = YES;
  
  [FBSettings setDefaultAppID:kFacebookAppID];
  [FBAppEvents activateApp];
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ([userDefaults objectForKey:kUserDefSpeakEnabled] == nil)
    [userDefaults setBool:YES forKey:kUserDefSpeakEnabled];
  
  if ([userDefaults objectForKey:kUserDefSoundEffectsEnabled] == nil)
    [userDefaults setBool:YES forKey:kUserDefSoundEffectsEnabled];
  
  [userDefaults synchronize];
  
#if kTestLogin
  [MUser logOutCurrentUser];
#endif
  [MUser loadCurrentUserFromUserDef];
  
  [AppsFlyerTracker sharedTracker].customerUserID = [MUser currentUser]._id;
  
  [[MMServerHelper apiHelper] getDictionary];
  
  NSDictionary *notificationData = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
  [self handlePushNotification:notificationData shouldShowAlert:YES];
  
  [self test];
}

- (void)handlePushNotification:(NSDictionary *)notificationData shouldShowAlert:(BOOL)shouldShowAlert {
  if (shouldShowAlert) {
    [self application:nil didReceiveRemoteNotification:notificationData];
    return;
  }
  
  if (notificationData == nil || ![notificationData isKindOfClass:[NSDictionary class]])
    return;
  
  NSDictionary *customData = notificationData[kParamCustomData];
  
  if (customData == nil || ![customData isKindOfClass:[NSDictionary class]])
    return;
  
  NSString *type = customData[kParamType];
  
  if ([type isEqualToString:kValuePushNotificationTypeFollow] &&
      customData[kParamData] != nil && [customData[kParamData] isKindOfClass:[NSString class]]) {
    BaseViewController *currentTopViewController = (BaseViewController *)_window.rootViewController;
    NSString *userId = customData[kParamData];
    MMProfileViewController *profileVC = [[MMProfileViewController alloc] initWithUserId:userId];
    [currentTopViewController presentViewController:[profileVC parentNavigationController] animated:YES completion:NULL];
    return;
  }
}

- (void)test {
  DLog(@"%@ %@", [MUser currentUser]._id, [MUser currentUser].auth_token);
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentFilePath = paths[0];
  DLog(@"%@", documentFilePath);
  
#if kTestCompactTranslation
  [NSString testCompactTranslations];
#endif
}

@end
