//
//  FTShareViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/23/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTShareViewController.h"

@interface FTShareViewController () {
  ShareOption _defaultShareOption;
}

- (void)setupViews;

@end

@implementation FTShareViewController

- (id)initWithDefaultOption:(ShareOption)defaultOption {
  if (self = [super init]) {
    _defaultShareOption = defaultOption;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:UIColorFromRGB(238, 238, 238)];
  [self customTitleWithText:NSLocalizedString(@"Share", nil) color:UIColorFromRGB(51, 51, 51)];
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  [self customBarButtonWithImage:nil
                           title:NSLocalizedString(@"Close", nil)
                           color:UIColorFromRGB(129, 12, 21)
                          target:self
                          action:@selector(dismissViewController)
                        distance:-8];
  
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)gestureLayerDidTap {
  [_txtComment resignFirstResponder];
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
  _txtPlaceholder.hidden = YES;
  [self gestureLayerDidEnterEditingMode];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  _txtPlaceholder.hidden = ![textView.text isEqualToString:@""];
}

- (IBAction)btnSocialServicePressed:(UIButton *)sender {
  sender.selected = !sender.selected;
}

- (IBAction)btnSubmitPressed:(UIButton *)sender {
  [self dismissViewController];
}

#pragma mark - Private methods
- (void)setupViews {
  _imgShareImage.superview.layer.cornerRadius = 5;
  _txtPlaceholder.font = [UIFont fontWithName:@"ClearSans" size:17];
  _txtPlaceholder.placeholder = NSLocalizedString(@"Write comment...", nil);
  _txtComment.font = [UIFont fontWithName:@"ClearSans" size:17];
  
  for (UIButton *button in _btnShareOptions) {
    button.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
    button.selected = button.tag == _defaultShareOption;
  }
  
  _btnSubmit.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnSubmit.layer.cornerRadius = 4;
}

@end
