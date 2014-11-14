//
//  Utils.m
//  giaothongvn
//
//  Created by Ethan Nguyen on 5/22/14.
//  Copyright (c) 2014 Volcano. All rights reserved.
//

#import "Utils.h"
#import "UIView+ExtendedToast.h"
#import "MBProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "iSpeechSDK.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>
#import <Mixpanel/Mixpanel.h>
#import "MMAppDelegate.h"
#import "MUser.h"

static UIView *_sharedToast = nil;

@interface Utils () <GPPSignInDelegate, ISSpeechRecognitionDelegate, AVAudioPlayerDelegate> {
  AVAudioPlayer *_audioPlayer;
  SystemSoundID _soundEffectId;
}

@property (nonatomic, strong) UIView *vAntLoading;
@property (nonatomic, strong) UIImageView *imgAntLoading;

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
- (void)setupAntLoadingView;
- (void)showAntLoadingInView:(UIView *)view;
- (void)hideAntLoading;
- (void)playSoundEffectWithName:(NSString *)effectName;

@end

@implementation Utils

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

+ (MBProgressHUD *)showHUDForView:(UIView *)view withText:(NSString *)text {
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hud.dimBackground = YES;
  
  return hud;
}

+ (void)hideAllHUDsForView:(UIView *)view {
  [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

+ (UIView *)showAntLoadingForView:(UIView *)view {
  Utils *sharedUtils = [Utils sharedUtils];
  
  if (sharedUtils.vAntLoading == nil)
    [sharedUtils setupAntLoadingView];
  
  if (sharedUtils.vAntLoading.superview != nil)
    [[self class] hideCurrentShowingAntLoading];
  
  [sharedUtils showAntLoadingInView:view];
  
  return sharedUtils.vAntLoading;
}

+ (void)hideCurrentShowingAntLoading {
  Utils *sharedUtils = [Utils sharedUtils];
  
  if (sharedUtils.vAntLoading.superview == nil)
    return;
  
  [sharedUtils hideAntLoading];
}

+ (void)adjustButtonToFitWidth:(UIButton *)button padding:(CGFloat)padding constrainsToWidth:(CGFloat)maxWidth {
  CGSize sizeThatFits = [button.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, button.frame.size.height)];
  sizeThatFits.width += padding;
  
  CGRect frame = button.frame;
  frame.size.width = MIN(sizeThatFits.width, maxWidth);
  button.frame = frame;
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

+ (void)setupAnalyticsForCurrentUser {
#if kTestModeNoAnalytics
  return;
#endif
  
  if ([MUser currentUser]._id == nil)
    return;
  
  [[Mixpanel sharedInstance] identify:[MUser currentUser]._id];
  [[Mixpanel sharedInstance].people set:[[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserDefSavedUser]];
}

+ (void)logAnalyticsForAppLaunched {
#if kTestModeNoAnalytics
  return;
#endif
  
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ios_app"
                                                        action:@"launched"
                                                         label:@"app launched"
                                                         value:nil] build]];
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ app launched %@",
                                    CurrentBuildVersion(), kBuildCurrentMarket]];
}

+ (void)logAnalyticsForUserLoggedIn {
#if kTestModeNoAnalytics
  return;
#endif
  
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ios_user"
                                                        action:@"logged_in"
                                                         label:@"user logged in"
                                                         value:nil] build]];
  
  NSDictionary *userData = nil;
  
  if ([MUser currentUser]._id != nil)
    userData = @{kParamUserId : [MUser currentUser]._id};
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ user logged in %@",
                                    CurrentBuildVersion(), kBuildCurrentMarket]
                        properties:userData];
}

+ (void)logAnalyticsForScreen:(NSString *)screenName {
#if kTestModeNoAnalytics
  return;
#endif
  
  NSDictionary *userData = nil;
  
  if ([MUser currentUser]._id != nil)
    userData = @{kParamUserId : [MUser currentUser]._id};
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ screen %@",
                                    CurrentBuildVersion(), [screenName normalizedScreenNameString]]
                        properties:userData];
}

+ (void)logAnalyticsForOnScreenStartTime:(NSString *)screenName {
#if kTestModeNoAnalytics
  return;
#endif
  
  [[Mixpanel sharedInstance] timeEvent:
   [NSString stringWithFormat:@"iOS %@ screen %@", CurrentBuildVersion(), [screenName normalizedScreenNameString]]];
}

+ (void)logAnalyticsForOnScreenEndTime:(NSString *)screenName {
#if kTestModeNoAnalytics
  return;
#endif
  
  NSDictionary *userData = nil;
  
  if ([MUser currentUser]._id != nil)
    userData = @{kParamUserId : [MUser currentUser]._id};
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ screen %@",
                                    CurrentBuildVersion(), [screenName normalizedScreenNameString]]
                        properties:userData];
}

+ (void)logAnalyticsForButton:(NSString *)buttonName {
#if kTestModeNoAnalytics
  return;
#endif
  
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ios_button"
                                                        action:@"click"
                                                         label:buttonName
                                                         value:nil] build]];
  
  NSDictionary *userData = nil;
  
  if ([MUser currentUser]._id != nil)
    userData = @{kParamUserId : [MUser currentUser]._id};
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ button click %@",
                                    CurrentBuildVersion(), buttonName]
                        properties:userData];
}

+ (void)logAnalyticsForButton:(NSString *)buttonName andProperties:(NSDictionary *)properties {
#if kTestModeNoAnalytics
  return;
#endif
  
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ios_button"
                                                        action:@"click"
                                                         label:buttonName
                                                         value:nil] build]];
  
  NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithDictionary:properties];
  
  if ([MUser currentUser]._id != nil)
    userData[kParamUserId] = [MUser currentUser]._id;
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ button click %@",
                                    CurrentBuildVersion(), buttonName]
                        properties:userData];
}

+ (void)logAnalyticsForScrollingOnScreen:(id)screen withScrollView:(UIScrollView *)scrollView {
#if kTestModeNoAnalytics
  return;
#endif
  
  NSString *screenName = NSStringFromClass([screen class]);
  
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ios_screen"
                                                        action:@"scroll"
                                                         label:[screenName normalizedScreenNameString]
                                                         value:nil] build]];
  
  NSMutableDictionary *userData =
  [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : NSStringFromCGPoint(scrollView.contentOffset)}];
  
  if ([MUser currentUser]._id != nil)
    userData[kParamUserId] = [MUser currentUser]._id;
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ screen scroll %@",
                                    CurrentBuildVersion(), [screenName normalizedScreenNameString]]
                        properties:userData];
}

+ (void)logAnalyticsForFocusTextField:(NSString *)textFieldName {
#if kTestModeNoAnalytics
  return;
#endif
  
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ios_textfield"
                                                        action:@"focus"
                                                         label:textFieldName
                                                         value:nil] build]];
  
  NSDictionary *userData = @{kParamUserId : @""};
  
  if ([MUser currentUser]._id != nil)
    userData = @{kParamUserId : [MUser currentUser]._id};
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ textfield focus %@",
                                    CurrentBuildVersion(), textFieldName]
                        properties:userData];
}

+ (void)logAnalyticsForSearchTextField:(NSString *)textFieldName withSearchText:(NSString *)searchText {
#if kTestModeNoAnalytics
  return;
#endif
  
  if (searchText == nil || ![searchText isKindOfClass:[NSString class]] || searchText.length == 0)
    return;
  
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ios_search"
                                                        action:@"text_search"
                                                         label:searchText
                                                         value:nil] build]];
  
  NSMutableDictionary *userData =
  [NSMutableDictionary dictionaryWithDictionary:@{@"text_search" : searchText}];
  
  if ([MUser currentUser]._id != nil)
    userData[kParamUserId] = [MUser currentUser]._id;
  
  [[Mixpanel sharedInstance] track:[NSString stringWithFormat:@"iOS %@ textfield search %@",
                                    CurrentBuildVersion(), textFieldName]
                        properties:userData];
}

+ (NSTimeInterval)benchmarkOperation:(void (^)())operation {
  if (operation == NULL)
    return -1;

  NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
  
  operation();
  
  NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
  
  return endTime - startTime;
}

+ (void)benchmarkOperationInBackground:(void (^)())operation completion:(void (^)(NSTimeInterval))handler {
  if (operation == NULL) {
    if (handler != NULL)
      handler(-1);
    
    return;
  }
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    
    operation();
    
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
      if (handler != NULL)
        handler(endTime - startTime);
      else
        DLog(@"%f", endTime - startTime);
    });
  });
}

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
      FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    [FBSession.activeSession closeAndClearTokenInformation];
  
  [FBSession
   openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
   allowLoginUI:YES
   completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
     BOOL sectionStateChangedResult = [appDelegate sessionStateChanged:session state:state error:error];
     
     if (!sectionStateChangedResult)
       return;
     
     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       if (error != nil) {
         callback(nil, error);
         return;
       }
       
       NSDictionary *userData = @{
                                  kParamFbName : [NSString normalizedString:result[kParamName]],
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
    [[self class] preDownloadAudioFromUrls:@[audioUrl]];
  
  NSString *savedAudioPath = [[self class] savedAudioPathWithOriginalUrl:audioUrl];
  [[Utils sharedUtils] playAudioWithPath:savedAudioPath];
}

+ (void)preDownloadAudioFromUrls:(NSArray *)audioUrls {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    for (NSString *audioUrl in audioUrls) {
#if kTestDownloadAudio
      NSURL *audioUri = [NSURL URLWithString:audioUrl];
#endif
      
      @autoreleasepool {
#if kTestDownloadAudio
        dispatch_sync(dispatch_get_main_queue(), ^{
          DLog(@"start download audio with %@", [audioUri lastPathComponent]);
        });
        
        NSString *savedAudioPath =
#endif
        
        [self saveTempAudioWithUrl:audioUrl];

#if kTestDownloadAudio
        dispatch_sync(dispatch_get_main_queue(), ^{
          DLog(@"finish download audio with %@ at path %@", [audioUri lastPathComponent], savedAudioPath);
        });
#endif
      }
    }
  });
}

+ (void)removePreDownloadedAudioWithOriginalUrls:(NSArray *)audioUrls {
  for (NSString *audioUrl in audioUrls)
    [[self class] removePreDownloadedAudio:audioUrl];
}

+ (void)playSoundEffect:(NSString *)effectName {
  if (![[NSUserDefaults standardUserDefaults] boolForKey:kUserDefSoundEffectsEnabled])
    return;
  
  [[Utils sharedUtils] playSoundEffectWithName:effectName];
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
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:NULL];
  _audioPlayer.delegate = self;
  [_audioPlayer prepareToPlay];
  [_audioPlayer play];
}

- (void)setupAntLoadingView {
  CGRect bounds = [UIScreen mainScreen].bounds;
  
  _vAntLoading = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, bounds.size}];
  
  _vAntLoading.backgroundColor = [UIColor clearColor];
  _vAntLoading.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  UIView *vLoadingBg = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, bounds.size}];
  vLoadingBg.backgroundColor = [UIColor blackColor];
  vLoadingBg.alpha = 0.7;
  vLoadingBg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [_vAntLoading addSubview:vLoadingBg];
  
  _imgAntLoading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-ant_loading-1.png"]];
  
  NSMutableArray *loadingImages = [NSMutableArray array];
  
  for (NSInteger i = 1; i <= 5; i++) {
    NSString *imageName = [NSString stringWithFormat:@"img-ant_loading-%ld.png", (long)i];
    [loadingImages addObject:[UIImage imageNamed:imageName]];
  }
  
  for (NSInteger i = 4; i >= 2; i--) {
    NSString *imageName = [NSString stringWithFormat:@"img-ant_loading-%ld.png", (long)i];
    [loadingImages addObject:[UIImage imageNamed:imageName]];
  }
  
  _imgAntLoading.animationImages = loadingImages;
  _imgAntLoading.animationDuration = [loadingImages count] * 0.1;
  _imgAntLoading.center = _vAntLoading.center;
  _imgAntLoading.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;;
  [_vAntLoading addSubview:_imgAntLoading];
}

- (void)showAntLoadingInView:(UIView *)view {
  _vAntLoading.frame = (CGRect){CGPointZero, view.frame.size};
  _vAntLoading.alpha = 0;
  [view addSubview:_vAntLoading];
  [_imgAntLoading startAnimating];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vAntLoading.alpha = 1;
   }
   completion:NULL];
}

- (void)hideAntLoading {
  [_imgAntLoading stopAnimating];
  
  [UIView
   animateWithDuration:kDefaultAnimationDuration
   delay:0
   options:UIViewAnimationOptionCurveEaseInOut
   animations:^{
     _vAntLoading.alpha = 0;
   }
   completion:^(BOOL finished) {
     [_vAntLoading removeFromSuperview];
   }];
}

- (void)playSoundEffectWithName:(NSString *)effectName {
  NSURL *soundEffectUrl = [NSURL fileURLWithPath:
                           [NSString stringWithFormat:@"%@/sound-fx-%@.mp3",
                            [[NSBundle mainBundle] resourcePath], effectName]];
  
  AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundEffectUrl, &_soundEffectId);
  AudioServicesPlaySystemSound(_soundEffectId);
}

@end

