//
//  Utils.m
//  giaothongvn
//
//  Created by Ethan Nguyen on 5/22/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import "Utils.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "UIView+ExtendedToast.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "iSpeechSDK.h"
#import "MMAppDelegate.h"

static UIView *_sharedToast = nil;

@interface Utils () <GPPSignInDelegate, ISSpeechRecognitionDelegate, AVAudioPlayerDelegate> {
  AVAudioPlayer *audioPlayer;
}

@property (nonatomic, strong) SocialLogInCallback googleLogInCallback;
@property (nonatomic, strong) SocialLogOutCallback googleLogOutCallback;
@property (nonatomic, strong) SpeechRecognitionCallback speechRecognitionCallback;

+ (instancetype)sharedUtils;
+ (NSString *)suffixForDayInDate:(NSDate *)date;
+ (BOOL)isObjectValidForSaveToUserDefaults:(id)object;
+ (NSString *)savedAudioPathWithOriginalUrl:(NSString *)audioUrl;
+ (BOOL)isAudioSavedWithOriginalUrl:(NSString *)audioUrl;
+ (NSString *)saveTempAudioWithUrl:(NSString *)audioUrl;
+ (void)removePreDownloadedAudio:(NSString *)audioUrl;
- (void)playAudioWithPath:(NSString *)audioPath;

@end

@implementation Utils

+ (UIAlertView *)showAlertWithError:(NSError *)error {
  return [[self class] showAlertWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Error %d", nil),
                                           [Utils errorCodeFromError:error]]
                               andMessage:[Utils errorMessageFromError:error]
                                 delegate:nil];
}

+ (UIAlertView *)showAlertWithError:(NSError *)error delegate:(id)delegate {
  return [[self class] showAlertWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Error %d", nil),
                                           [Utils errorCodeFromError:error]]
                               andMessage:[Utils errorMessageFromError:error]
                                 delegate:delegate];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
  return [[self class] showAlertWithTitle:title andMessage:message delegate:nil];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message delegate:(id)delegate {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:delegate
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
  [alertView show];
  
  return alertView;
}

+ (void)showToastWithMessage:(NSString *)toastMessage {
  UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
  
  if (_sharedToast != nil) {
    [_sharedToast removeFromSuperview];
    _sharedToast = nil;
  }
  
  _sharedToast = [topWindow toastWithMessage:toastMessage];
  [topWindow showToast:_sharedToast];
}

+ (void)showToastWithError:(NSError *)error {
  [Utils showToastWithMessage:[error description]];
}

+ (NSString *)errorMessageFromError:(NSError *)error {
  if (error == nil || ![error isKindOfClass:[NSError class]])
    return NSLocalizedString(@"Unknown error!", nil);
  
  if (error.userInfo == nil || ![error.userInfo isKindOfClass:[NSDictionary class]] ||
      error.userInfo[kServerResponseDataKey] == nil || error.userInfo[kServerResponseDataKey] == NULL ||
      [error.userInfo[kServerResponseDataKey] isEqualToData:[NSData data]])     // Empty data
    return [error localizedDescription];

  NSDictionary *errorDict = [error.userInfo[kServerResponseDataKey] objectFromJSONData];
  
  if (errorDict == nil || ![errorDict isKindOfClass:[NSDictionary class]] ||
      errorDict[kParamError] == nil || ![errorDict[kParamError] isKindOfClass:[NSString class]])
    return [error localizedDescription];
  
  return NSLocalizedString(errorDict[kParamError], nil);
}

+ (NSInteger)errorCodeFromError:(NSError *)error {
  if (error == nil || ![error isKindOfClass:[NSError class]])
    return -1;
  
  if (error.userInfo == nil || ![error.userInfo isKindOfClass:[NSDictionary class]] ||
      error.userInfo[kServerResponseDataKey] == nil || error.userInfo[kServerResponseDataKey] == NULL ||
      [error.userInfo[kServerResponseDataKey] isEqualToData:[NSData data]])     // Empty data
    return [error code];
  
  NSDictionary *errorDict = [error.userInfo[kServerResponseDataKey] objectFromJSONData];
  
  if (errorDict == nil || ![errorDict isKindOfClass:[NSDictionary class]] ||
      errorDict[kParamResponseCode] == nil || ![errorDict[kParamResponseCode] isKindOfClass:[NSNumber class]])
    return [error code];
  
  return [errorDict[kParamResponseCode] integerValue];
}

+ (MBProgressHUD *)showHUDForView:(UIView *)view withText:(NSString *)text {
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hud.dimBackground = YES;
  
  return hud;
}

+ (void)hideAllHUDsForView:(UIView *)view {
  [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

+ (BOOL)validateEmail:(NSString *)email {
  BOOL stricterFilter = YES;
  
  NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
  NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  
  return [predicate evaluateWithObject:email];
}

+ (BOOL)validateAlphaNumeric:(NSString *)password {
  NSString *myRegex = @"[A-Z0-9a-z_]*";
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
  return [predicate evaluateWithObject:password];
}

+ (BOOL)validateBlank:(NSString *)string {
  if (string == nil || ![string isKindOfClass:[NSString class]])
    return NO;
  
  NSString *filtedString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
  filtedString = [filtedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  
  return ![filtedString isEqualToString:@""];
}

+ (NSString *)uniqueDeviceIdentifier {
  NSString *uniqueIdentifier = nil;
  
  // iOS 6+
  if ([UIDevice instancesRespondToSelector:@selector(identifierForVendor)])
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  // before iOS 6
  uniqueIdentifier = [userDefaults objectForKey:kUserDefUDID];
  
  if (uniqueIdentifier == nil) {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    uniqueIdentifier = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    CFRelease(uuid);
    
    [userDefaults setObject:uniqueIdentifier forKey:kUserDefUDID];
    [userDefaults synchronize];
  }
  
  return uniqueIdentifier;
}

+ (NSString*)trimmedDeviceToken:(NSData*)token {
  NSString *trimmedToken = [token description];
  trimmedToken = [trimmedToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  trimmedToken = [trimmedToken stringByReplacingOccurrencesOfString:@" " withString:@""];
  return trimmedToken;
}

+ (NSString *)getDeviceModel {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *model = malloc(size);
  sysctlbyname("hw.machine", model, &size, NULL, 0);
  NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
  free(model);
  
  if ([deviceModel isEqualToString:@"i386"] || [deviceModel isEqualToString:@"x86_64"])
    return nil;
  
  return deviceModel;
}

+ (void)adjustLabelToFitHeight:(UILabel *)label {
  [self adjustLabelToFitHeight:label relatedTo:nil withDistance:0];
}

+ (void)adjustLabelToFitHeight:(UILabel *)label constrainsToHeight:(CGFloat)maxHeight {
  [self adjustLabelToFitHeight:label relatedTo:nil withDistance:0];
  
  CGRect frame = label.frame;
  frame.size.height = MIN(frame.size.height, maxHeight);
  label.frame = frame;
}

+ (void)adjustLabelToFitHeight:(UILabel *)label relatedTo:(UILabel *)otherLabel withDistance:(CGFloat)distance {
  CGSize sizeThatFits = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
  CGRect frame = label.frame;
  
  if (otherLabel != nil)
    frame.origin.y = otherLabel.frame.origin.y + otherLabel.frame.size.height + distance;
  
  frame.size.height = sizeThatFits.height;
  label.frame = frame;
}

+ (void)adjustLabelToFitHeight:(UILabel *)label
            constrainsToHeight:(CGFloat)maxHeight
                     relatedTo:(UILabel *)otherLabel
                  withDistance:(CGFloat)distance {
  CGSize sizeThatFits = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
  CGRect frame = label.frame;
  
  if (otherLabel != nil)
    frame.origin.y = otherLabel.frame.origin.y + otherLabel.frame.size.height + distance;
  
  frame.size.height = MIN(sizeThatFits.height, maxHeight);
  label.frame = frame;
}

+ (void)applyAttributedTextForLabel:(UILabel *)label
                           withText:(NSString *)fullText
                           onString:(NSString *)styledString
                     withAttributes:(NSDictionary *)attributes {
  NSRange styledRange = [fullText rangeOfString:styledString];
  
  if (styledRange.location == NSNotFound) {
    label.text = fullText;
    return;
  }
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullText];
  [attributedText addAttributes:attributes range:styledRange];
  
  label.attributedText = attributedText;
}

+ (CGFloat)keyboardShrinkRatioForView:(UIView *)view {
  CGFloat actualContentViewsHeight = 0;
  
  for (UIView *subview in view.subviews)
    if (subview.frame.origin.y + subview.frame.size.height > actualContentViewsHeight)
      actualContentViewsHeight = subview.frame.origin.y + subview.frame.size.height;
  
  CGFloat actualOriginY = [view.superview convertPoint:view.frame.origin toView:nil].y;
  CGFloat nonKeyboardViewHeight = [UIScreen mainScreen].bounds.size.height - kHeightKeyboard - actualOriginY;
  
  return nonKeyboardViewHeight / actualContentViewsHeight;
}

//+ (BOOL)isDeviceCapableForRealTimeSearch {
//  NSString *deviceModel = [self getDeviceModel];
//  
//  if (deviceModel == nil)
//    return YES;
//  
//  if ([deviceModel rangeOfString:@"iPod"].location != NSNotFound)
//    return NO;
//  
//  if ([deviceModel rangeOfString:@"iPad"].location != NSNotFound) {
//    CGFloat version = [[[deviceModel stringByReplacingOccurrencesOfString:@"iPad" withString:@""]
//                        stringByReplacingOccurrencesOfString:@"," withString:@"."]
//                       floatValue];
//    
//    return version >= 2.5;
//  }
//  
//  if ([deviceModel rangeOfString:@"iPhone"].location != NSNotFound) {
//    CGFloat version = [[[deviceModel stringByReplacingOccurrencesOfString:@"iPhone" withString:@""]
//                        stringByReplacingOccurrencesOfString:@"," withString:@"."]
//                       floatValue];
//    
//    return version >= 5;
//  }
//  
//  return NO;
//}
//
//+ (void)logAnalyticsForScreen:(NSString *)screenName {
//  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//  [tracker set:kGAIScreenName value:[NSString stringWithFormat:@"Screen %@", screenName]];
//  [tracker send:[[GAIDictionaryBuilder createAppView] build]];
//}
//
//+ (void)logAnalyticsForSearchText:(NSString *)searchText {
//  if (searchText == nil || ![searchText isKindOfClass:[NSString class]] || searchText.length == 0)
//    return;
//  
//  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"all_articles"
//                                                        action:@"search"
//                                                         label:searchText
//                                                         value:nil] build]];
//}

#pragma mark - User utils methods
+ (NSDictionary *)updateSavedUserWithAttributes:(NSDictionary *)attributes {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *savedUser = [NSMutableDictionary dictionaryWithDictionary:
                                    [userDefaults dictionaryForKey:kUserDefSavedUser]];
  
  [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([[self class] isObjectValidForSaveToUserDefaults:obj])
      savedUser[key] = obj;
  }];
  
  [userDefaults setObject:[NSDictionary dictionaryWithDictionary:savedUser] forKey:kUserDefSavedUser];
  [userDefaults synchronize];
  
  return savedUser;
}

+ (void)logInFacebookFromView:(UIView *)view completion:(SocialLogInCallback)callback {
  MMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  
  if (FBSession.activeSession.state == FBSessionStateOpen ||
      FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
    [FBSession.activeSession closeAndClearTokenInformation];
    return;
  }
  
  [FBSession
   openActiveSessionWithReadPermissions:@[@"public_profile"]
   allowLoginUI:YES
   completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
     BOOL sectionStateChangedResult = [appDelegate sessionStateChanged:session state:state error:error];
     
     if (!sectionStateChangedResult)
       return;
     
     [Utils showHUDForView:view withText:nil];
     
     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       if (error != nil) {
         [Utils hideAllHUDsForView:view];
         return;
       }
       
       [Utils hideAllHUDsForView:view];
       
       NSDictionary *userData = @{
                                  kParamFbId : [NSString normalizedString:result[kParamId]],
                                  kParamFbAccessToken : [NSString normalizedString:
                                                         [[FBSession activeSession] accessTokenData].accessToken]
                                  };
       
       if (callback != NULL)
         callback(userData, error);
     }];
   }];
}

+ (void)logOutFacebookWithCompletion:(SocialLogOutCallback)callback {
  [[FBSession activeSession] closeAndClearTokenInformation];
  
  if (callback != NULL)
    callback(nil);
}

+ (void)logInGoogleFromView:(UIView *)view completion:(SocialLogInCallback)callback {
  Utils *utils = [Utils sharedUtils];
  utils.googleLogInCallback = callback;
  
  GPPSignIn *signIn = [GPPSignIn sharedInstance];
  
  signIn.shouldFetchGoogleUserEmail = YES;
  signIn.clientID = kGoogleSignInKey;
  signIn.scopes = @[@"profile"];
  signIn.delegate = utils;
  
  [signIn authenticate];
}

+ (void)logOutGoogleWithCompletion:(void (^)(NSError *))callback {
  [[Utils sharedUtils] setGoogleLogOutCallback:callback];
  [[GPPSignIn sharedInstance] disconnect];
}

#pragma mark - Lessons learning utils
+ (void)recognizeWithCompletion:(void (^)(ISSpeechRecognitionResult *, NSError *))callback {
#if TARGET_IPHONE_SIMULATOR
  if (callback != NULL)
    callback(nil, nil);
#else
  ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];
  recognition.delegate = [Utils sharedUtils];
  
  NSError *error = nil;
  
  [Utils sharedUtils].speechRecognitionCallback = callback;
  
  if (![recognition listenAndRecognizeWithTimeout:30 error:&error]) {
    if (callback != NULL)
      callback(nil, error);
  }
#endif
}

+ (void)playAudioWithUrl:(NSString *)audioUrl {
  if (![[self class] isAudioSavedWithOriginalUrl:audioUrl])
    [[self class] downloadMultipleAudioFromUrls:@[audioUrl]];
  
  NSString *savedAudioPath = [[self class] savedAudioPathWithOriginalUrl:audioUrl];
  DLog(@"%@", savedAudioPath);
  [[Utils sharedUtils] playAudioWithPath:savedAudioPath];
}

+ (void)downloadMultipleAudioFromUrls:(NSArray *)audioUrls {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    for (NSString *audioUrl in audioUrls) {
      NSURL *audioUri = [NSURL URLWithString:audioUrl];
      
      @autoreleasepool {
        dispatch_sync(dispatch_get_main_queue(), ^{
          DLog(@"start download audio with %@", [audioUri lastPathComponent]);
        });
        
        NSString *savedAudioPath = [self saveTempAudioWithUrl:audioUrl];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
          DLog(@"finish download audio with %@ at path %@", [audioUri lastPathComponent], savedAudioPath);
        });
      }
    }
  });
}

+ (void)removeMultipleAudioWithOriginalUrls:(NSArray *)audioUrls {
  for (NSString *audioUrl in audioUrls)
    [[self class] removePreDownloadedAudio:audioUrl];
}

#pragma mark - GPPSignInDelegate methods
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
  if (_googleLogInCallback == NULL)
    return;
  
  NSDictionary *userData = @{
                             kParamGmail : [NSString normalizedString:auth.userEmail],
                             kParamGAccessToken : [NSString normalizedString:auth.accessToken]
                             };
  
  _googleLogInCallback(userData, error);
}

- (void)didDisconnectWithError:(NSError *)error {
  if (_googleLogOutCallback == NULL)
    return;
  
  _googleLogOutCallback(error);
}

#pragma mark - ISSpeechRecognitionDelegate methods
- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
  if (_speechRecognitionCallback == NULL)
    return;
  
  _speechRecognitionCallback(nil, error);
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {
  if (_speechRecognitionCallback == NULL)
    return;
  
  _speechRecognitionCallback(result, nil);
}

#pragma mark - AVAudioPlayerDelegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  [player stop];
}

#pragma mark - Private methods
+ (instancetype)sharedUtils {
  static Utils *_sharedUtils = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedUtils = [Utils new];
  });
  
  return _sharedUtils;
}

+ (NSString *)suffixForDayInDate:(NSDate *)date {
  NSInteger day = [[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]
                    components:NSDayCalendarUnit fromDate:date] day];
  
  if (day >= 11 && day <= 13)
    return @"th";
  
  if (day % 10 == 1)
    return @"st";
  
  if (day % 10 == 2)
    return @"nd";
  
  if (day % 10 == 3)
    return @"rd";
  
  return @"th";
}

+ (BOOL)isObjectValidForSaveToUserDefaults:(id)object {
  NSArray *validKlasses = @[
                            [NSArray class], [NSDictionary class], [NSString class],
                            [NSData class], [NSNumber class], [NSDate class]
                            ];
  
  for (Class klass in validKlasses)
    if ([object isKindOfClass:klass])
      return YES;
  
  return NO;
}

+ (NSString *)savedAudioPathWithOriginalUrl:(NSString *)audioUrl {
  NSFileManager *manager = [NSFileManager defaultManager];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *savedAudioFilePath = paths[0];
  [manager createDirectoryAtPath:savedAudioFilePath withIntermediateDirectories:YES attributes:nil error:nil];
  
  NSURL *audioUri = [NSURL URLWithString:audioUrl];
  NSString *audioFileName = [audioUri lastPathComponent];
  
  savedAudioFilePath = [savedAudioFilePath stringByAppendingPathComponent:audioFileName];

  return savedAudioFilePath;
}

+ (BOOL)isAudioSavedWithOriginalUrl:(NSString *)audioUrl {
  NSString *savedAudioFilePath = [[self class] savedAudioPathWithOriginalUrl:audioUrl];
  return [[NSFileManager defaultManager] fileExistsAtPath:savedAudioFilePath];
}

+ (NSString *)saveTempAudioWithUrl:(NSString *)audioUrl {
  NSString *savedAudioPath = [[self class] savedAudioPathWithOriginalUrl:audioUrl];
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:savedAudioPath])
    return savedAudioPath;
  
  [self removePreDownloadedAudio:audioUrl];
  
  // download & save to path
  NSData *urlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:audioUrl]];
  
  if (urlData != nil)
    [urlData writeToFile:savedAudioPath atomically:YES];
  
  return savedAudioPath;
}

+ (void)removePreDownloadedAudio:(NSString *)audioUrl {
  NSString *savedAudioFilePath = [[self class] savedAudioPathWithOriginalUrl:audioUrl];
  [[NSFileManager defaultManager] removeItemAtPath:savedAudioFilePath error:nil];
}

- (void)playAudioWithPath:(NSString *)audioPath {
  NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
  audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:NULL];
  audioPlayer.delegate = self;
  [audioPlayer prepareToPlay];
  [audioPlayer play];
}

@end

