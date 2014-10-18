//
//  FTCongratsViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMCongratsViewController.h"
#import "MMShareActionSheet.h"
#import "MUser.h"

@interface MMCongratsViewController () {
  MMShareActionSheet *_vShare;
}

- (NSInteger)displayingLevel;
- (NSString *)displayingMessage;
- (NSString *)displayingSubMessage;

@end

@implementation MMCongratsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _imgAnt.frame;
    frame.origin.y = DeviceSystemIsOS7() ? -34 : -44;
    _imgAnt.frame = frame;
    
    frame = _vLevelUp.frame;
    frame.origin.y = DeviceSystemIsOS7() ? 100 : 80;
    _vLevelUp.frame = frame;
    
    frame = _lblMessage.frame;
    frame.origin.y = _imgAnt.frame.origin.y + _imgAnt.frame.size.height + (DeviceSystemIsOS7() ? 5 : 5);
    _lblMessage.frame = frame;
    
    frame = _lblSubMessage.frame;
    frame.origin.y = _lblMessage.frame.origin.y + _lblMessage.frame.size.height + (DeviceSystemIsOS7() ? 7 : 5);
    _lblSubMessage.frame = frame;
  }
  
  NSInteger level = [self displayingLevel];
  _vLevelUp.hidden = level <= 0;
  
  if (!_vLevelUp.hidden) {
    _lblLevel.font = [UIFont fontWithName:@"ClearSans-Bold" size:30];
    _lblLevel.text = [NSString stringWithFormat:@"%d", level];
  }
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblMessage.text = [self displayingMessage];
  _lblMessage.adjustsFontSizeToFitWidth = YES;
  [_lblMessage adjustToFitHeightAndConstrainsToHeight:48];
  
  CGRect frame = _lblMessage.frame;
  frame.origin.y = _vLevelUp.frame.origin.y + _vLevelUp.frame.size.height + 10;
  _lblMessage.frame = frame;
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblSubMessage.text = [self displayingSubMessage];
  _lblSubMessage.adjustsFontSizeToFitWidth = YES;
  [_lblSubMessage adjustToFitHeightAndConstrainsToHeight:(DeviceScreenIsRetina4Inch() ? 72 : 48)
                                               relatedTo:_lblMessage
                                            withDistance:10];
  
  _btnShare.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnShare.layer.cornerRadius = 4;
  [_btnShare setTitle:MMLocalizedString(@"Share") forState:UIControlStateNormal];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:MMLocalizedString(@"Next") forState:UIControlStateNormal];
  
  _vShare = [[MMShareActionSheet alloc] initInViewController:self];
  
#if kTempDisableForCloseBeta
  _btnShare.hidden = YES;
#endif
}

- (IBAction)btnSharePressed:(UIButton *)sender {
  [_vShare show];
}

- (IBAction)btnNextPressed:(UIButton *)sender {
}

#pragma mark - MMActionSheetDelegate methods
- (void)actionSheetDidSelectAtIndex:(NSInteger)index {
  [self presentShareViewControllerWithDefaultOption:(ShareOption)index];
}

#pragma mark - Private methods
- (NSInteger)displayingLevel {
  NSNumber *leveledUp = [MUser currentUser].lastReceivedBonuses[kParamLeveledUp];
  
  if (leveledUp == nil || ![leveledUp isKindOfClass:[NSNumber class]] || ![leveledUp boolValue])
    return -1;
  
  NSNumber *level = [MUser currentUser].lastReceivedBonuses[kParamLevel];
  
  if (level == nil || ![level isKindOfClass:[NSNumber class]])
    return -1;
  
  return [level integerValue];
}

- (NSString *)displayingMessage {
  if (_displayingData == nil || ![_displayingData isKindOfClass:[NSDictionary class]] ||
      _displayingData[kParamMessage] == nil || ![_displayingData[kParamMessage] isKindOfClass:[NSString class]])
    return @"";
  
  return _displayingData[kParamMessage];
}

- (NSString *)displayingSubMessage {
  if (_displayingData == nil || ![_displayingData isKindOfClass:[NSDictionary class]] ||
      _displayingData[kParamSubMessage] == nil || ![_displayingData[kParamSubMessage] isKindOfClass:[NSString class]])
    return @"";
  
  return _displayingData[kParamSubMessage];
}

@end
