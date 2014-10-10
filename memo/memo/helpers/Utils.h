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

+ (UIAlertView *)showAlertWithError:(NSError *)error;
+ (UIAlertView *)showAlertWithError:(NSError *)error delegate:(id)delegate;
+ (UIAlertView *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (UIAlertView *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message delegate:(id)delegate;

+ (void)showToastWithMessage:(NSString *)toastMessage;
+ (void)showToastWithError:(NSError *)error;

+ (NSString *)errorMessageFromError:(NSError *)error;
+ (NSInteger)errorCodeFromError:(NSError *)error;

+ (MBProgressHUD *)showHUDForView:(UIView *)view withText:(NSString *)text;
+ (void)hideAllHUDsForView:(UIView *)view;

+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validateAlphaNumeric:(NSString *)password;
+ (BOOL)validateBlank:(NSString *)string;

+ (NSString *)uniqueDeviceIdentifier;
+ (NSString *)trimmedDeviceToken:(NSData *)deviceToken;

+ (void)adjustLabelToFitHeight:(UILabel *)label;
+ (void)adjustLabelToFitHeight:(UILabel *)label constrainsToHeight:(CGFloat)maxHeight;
+ (void)adjustLabelToFitHeight:(UILabel *)label relatedTo:(UILabel *)otherLabel withDistance:(CGFloat)distance;
+ (void)adjustLabelToFitHeight:(UILabel *)label
            constrainsToHeight:(CGFloat)maxHeight
                     relatedTo:(UILabel *)otherLabel
                  withDistance:(CGFloat)distance;

+ (void)adjustButtonToFitWidth:(UIButton *)button padding:(CGFloat)padding constrainsToWidth:(CGFloat)maxWidth;

+ (void)applyAttributedTextForLabel:(UILabel *)label
                           withText:(NSString *)fullText
                           onString:(NSString *)styledString
                     withAttributes:(NSDictionary *)attributes;
+ (CGFloat)keyboardShrinkRatioForView:(UIView *)view;

+ (NSString *)getDeviceModel;
//+ (BOOL)isDeviceCapableForRealTimeSearch;
//+ (void)logAnalyticsForScreen:(NSString *)screenName;
//+ (void)logAnalyticsForSearchText:(NSString *)searchText;

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

@end

