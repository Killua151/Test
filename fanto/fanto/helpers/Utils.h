//
//  Utils.h
//  giaothongvn
//
//  Created by Ethan Nguyen on 5/22/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBProgressHUD, GTMOAuth2Authentication;

@interface Utils : NSObject

typedef void(^SocialLogInCallback)(NSDictionary *userData, NSError *error);
typedef void(^SocialLogOutCallback)(NSError *error);

+ (UIAlertView *)showAlertWithError:(NSError *)error;
+ (UIAlertView *)showAlertWithError:(NSError *)error delegate:(id)delegate;
+ (UIAlertView *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (UIAlertView *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message delegate:(id)delegate;

+ (void)showToastWithMessage:(NSString *)toastMessage;
+ (void)showToastWithError:(NSError *)error;

+ (MBProgressHUD *)showHUDForView:(UIView *)view withText:(NSString *)text;
+ (void)hideAllHUDsForView:(UIView *)view;

+ (NSString *)normalizeString:(NSString *)string;
+ (NSString *)normalizeString:(NSString *)string withPlaceholder:(NSString *)placeholder;
+ (NSString *)asciiNormalizedString:(NSString *)unicodeString;

+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validateAlphaNumeric:(NSString *)password;
+ (BOOL)validateBlank:(NSString *)string;

+ (NSString *)uniqueDeviceIdentifier;

+ (void)adjustLabelToFitHeight:(UILabel *)label;
+ (void)adjustLabelToFitHeight:(UILabel *)label relatedTo:(UILabel *)otherLabel withDistance:(CGFloat)distance;

#pragma mark - String number methods
+ (BOOL)floatValueIsInteger:(CGFloat)value;
+ (NSString *)stringForFloatValue:(CGFloat)value shouldDisplayZero:(BOOL)displayZero;
+ (NSString *)listStringForArray:(NSArray *)array withJoinStringForLastItem:(NSString *)lastJoinString;

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

@end

