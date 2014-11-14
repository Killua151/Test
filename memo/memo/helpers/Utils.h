//
//  Utils.h
//  giaothongvn
//
//  Created by Ethan Nguyen on 5/22/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBProgressHUD, GTMOAuth2Authentication, ISSpeechRecognitionResult;

@interface Utils : NSObject

typedef void(^SocialLogInCallback)(NSDictionary *userData, NSError *error);
typedef void(^SocialLogOutCallback)(NSError *error);
typedef void(^SpeechRecognitionCallback)(ISSpeechRecognitionResult *result, NSError *error);

+ (void)showToastWithMessage:(NSString *)toastMessage;
+ (void)showToastWithError:(NSError *)error;

+ (MBProgressHUD *)showHUDForView:(UIView *)view withText:(NSString *)text;
+ (void)hideAllHUDsForView:(UIView *)view;

+ (UIView *)showAntLoadingForView:(UIView *)view;
+ (void)hideCurrentShowingAntLoading;

+ (void)adjustButtonToFitWidth:(UIButton *)button padding:(CGFloat)padding constrainsToWidth:(CGFloat)maxWidth;

+ (CGFloat)keyboardShrinkRatioForView:(UIView *)view;

+ (void)setupAnalyticsForCurrentUser;
+ (void)logAnalyticsForAppLaunched;
+ (void)logAnalyticsForUserLoggedIn;
+ (void)logAnalyticsForScreen:(NSString *)screenName;
+ (void)logAnalyticsForOnScreenStartTime:(NSString *)screenName;
+ (void)logAnalyticsForOnScreenEndTime:(NSString *)screenName;
+ (void)logAnalyticsForButton:(NSString *)buttonName;
+ (void)logAnalyticsForButton:(NSString *)buttonName andProperties:(NSDictionary *)properties;
+ (void)logAnalyticsForScrollingOnScreen:(NSString *)screenName toOffset:(CGPoint)toOffset;
+ (void)logAnalyticsForFocusTextField:(NSString *)textFieldName;
+ (void)logAnalyticsForSearchTextField:(NSString *)textFieldName withSearchText:(NSString *)searchText;

+ (NSTimeInterval)benchmarkOperation:(void(^)())operation;
+ (void)benchmarkOperationInBackground:(void(^)())operation completion:(void(^)(NSTimeInterval elapsedTime))handler;

#pragma mark - User utils methods
+ (NSDictionary *)updateSavedUserWithAttributes:(NSDictionary *)attributes;
+ (void)logInFacebookFromView:(UIView *)view completion:(SocialLogInCallback)callback;
+ (void)logOutFacebookWithCompletion:(SocialLogOutCallback)callback;
+ (void)logInGoogleFromView:(UIView *)view completion:(SocialLogInCallback)callback;
+ (void)logOutGoogleWithCompletion:(SocialLogOutCallback)callback;

#pragma mark - Lessons learning utils
+ (void)recognizeWithCompletion:(SpeechRecognitionCallback)callback;
+ (void)playAudioWithUrl:(NSString *)audioUrl;
+ (void)preDownloadAudioFromUrls:(NSArray *)audioUrls;
+ (void)removePreDownloadedAudioWithOriginalUrls:(NSArray *)audioUrls;
+ (void)playSoundEffect:(NSString *)effectName;

@end

