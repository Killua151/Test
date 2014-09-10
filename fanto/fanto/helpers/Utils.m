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
#import <Toast/UIView+Toast.h>

@interface Utils ()

+ (NSString *)suffixForDayInDate:(NSDate *)date;

@end

@implementation Utils

+ (UIAlertView *)showAlertWithError:(NSError *)error {
  return [[self class] showAlertWithTitle:@"Lỗi" andMessage:[error localizedDescription] delegate:nil];
}

+ (UIAlertView *)showAlertWithError:(NSError *)error delegate:(id)delegate {
  return [[self class] showAlertWithTitle:@"Lỗi" andMessage:[error localizedDescription] delegate:delegate];
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
  [topWindow makeToast:toastMessage];
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

+ (NSString *)normalizeString:(NSString *)string {
  return [self normalizeString:string withPlaceholder:@""];
}

+ (NSString *)normalizeString:(NSString *)string withPlaceholder:(NSString *)placeholder {
  return string == nil || ![string isKindOfClass:[NSString class]] ? placeholder : string;
}

+ (NSString *)asciiNormalizedString:(NSString *)unicodeString {
  NSString *stringToNormalize = [Utils normalizeString:unicodeString];
  
  NSString *standard = [stringToNormalize stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
  standard = [standard stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
  NSData *decode = [standard dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *asciiString = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
  
  return asciiString;
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

+ (void)adjustLabelToFitHeight:(UILabel *)label relatedTo:(UILabel *)otherLabel withDistance:(CGFloat)distance {
  CGSize sizeThatFits = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
  CGRect frame = label.frame;
  
  if (otherLabel != nil)
    frame.origin.y = otherLabel.frame.origin.y + otherLabel.frame.size.height + distance;
  
  frame.size.height = sizeThatFits.height;
  label.frame = frame;
}

+ (BOOL)floatValueIsInteger:(CGFloat)value {
  NSString *valueString = [NSString stringWithFormat:@"%.2f", value];
  
  return [[valueString componentsSeparatedByString:@"."][1] isEqualToString:@"00"];
}

+ (NSString *)stringForFloatValue:(CGFloat)value shouldDisplayZero:(BOOL)displayZero {
  if (value == 0.0 && !displayZero)
    return @"";
  
  if ([Utils floatValueIsInteger:value])
    return [NSString stringWithFormat:@"%d", (int)value];
  
  return [NSString stringWithFormat:@"%.2f", value];
}

+ (NSString *)listStringForArray:(NSArray *)array withJoinStringForLastItem:(NSString *)lastJoinString {
  if (array == nil || ![array isKindOfClass:[NSArray class]] || [array count] == 0)
    return @"";
  
  if (lastJoinString == nil)
    return [array componentsJoinedByString:@", "];
  
  if ([array count] == 1)
    return [array firstObject];
  
  NSArray *subArray = [array subarrayWithRange:NSMakeRange(0, [array count]-1)];
  
  return [NSString stringWithFormat:@"%@ %@ %@", [subArray componentsJoinedByString:@", "], lastJoinString, [array lastObject]];
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

#pragma mark - Private methods
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

@end

