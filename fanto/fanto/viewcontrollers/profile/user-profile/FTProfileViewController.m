//
//  FTProfileViewController.m
//  fanto
//
//  Created by Ethan on 9/18/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTProfileViewController.h"
#import "FTSettingsViewController.h"

@interface FTProfileViewController () {
  FTSettingsViewController *_settingsVC;
}

- (void)gotoSettings;
- (void)dismissViewController;

@end

@implementation FTProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customNavBarBgWithColor:UIColorFromRGB(223, 223, 223)];
  [self customTitleWithText:NSLocalizedString(@"Profile", nil) color:[UIColor blackColor]];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Settings", nil)
                           color:[UIColor blackColor]
                          target:self
                          action:@selector(gotoSettings)
                        distance:8];
  
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Close", nil)
                           color:[UIColor blackColor]
                          target:self
                          action:@selector(dismissViewController)
                        distance:-8];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  _settingsVC = nil;
}

#pragma mark - Private methods
- (void)gotoSettings {
  if (_settingsVC == nil)
    _settingsVC = [FTSettingsViewController new];
  
  [self.navigationController pushViewController:_settingsVC animated:YES];
  [_settingsVC reloadContents];
}

- (void)dismissViewController {
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

@end
