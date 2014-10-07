//
//  FTCongratsViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMCongratsViewController.h"
#import "FTShareActionSheet.h"

@interface MMCongratsViewController () {
  FTShareActionSheet *_vShare;
}

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
    
    frame = _lblMessage.frame;
    frame.origin.y = _imgAnt.frame.origin.y + _imgAnt.frame.size.height + (DeviceSystemIsOS7() ? 5 : 5);
    _lblMessage.frame = frame;
    
    frame = _lblSubMessage.frame;
    frame.origin.y = _lblMessage.frame.origin.y + _lblMessage.frame.size.height +
    (DeviceSystemIsOS7() ? 7 : 5);
    _lblSubMessage.frame = frame;
  }
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  [Utils adjustLabelToFitHeight:_lblMessage];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  [Utils adjustLabelToFitHeight:_lblSubMessage];
  
  _btnShare.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnShare.layer.cornerRadius = 4;
  [_btnShare setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
  
  _vShare = [[FTShareActionSheet alloc] initInViewController:self];
}

- (IBAction)btnSharePressed:(UIButton *)sender {
  [_vShare show];
}

- (IBAction)btnNextPressed:(UIButton *)sender {
}

#pragma mark - FTActionSheetDelegate methods
- (void)actionSheetDidSelectAtIndex:(NSInteger)index {
  [self presentShareViewControllerWithDefaultOption:(ShareOption)index];
}

@end
