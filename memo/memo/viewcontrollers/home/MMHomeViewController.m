//
//  FTHomeViewController.m
//  fanto
//
//  Created by Ethan on 9/12/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMHomeViewController.h"
#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMCoursesListViewController.h"

#import "MMCongratsViewController.h"

@interface MMHomeViewController () {
  MMLoginViewController *_loginVC;
  MMSignUpViewController *_signUpVC;
  MMCoursesListViewController *_coursesListVC;
}

- (void)setupViews;

@end

@implementation MMHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customTitleWithText:@"" color:[UIColor clearColor]];
  
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  _loginVC = nil;
  _signUpVC = nil;
  _coursesListVC = nil;
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  if (_loginVC == nil)
    _loginVC = [MMLoginViewController new];
  
  [self.navigationController pushViewController:_loginVC animated:YES];
  [_loginVC reloadContents];
}

- (IBAction)btnNewUserPressed:(UIButton *)sender {
  MMCongratsViewController *congratsVC = [MMCongratsViewController new];
  
  NSString *subMessage = [NSString stringWithFormat:
                          MMLocalizedString(@"Giờ bạn đã đạt cấp %d của ngôn ngữ %@, tiếp tục rèn luyện thêm nhé!"),
                          10, @"Tiếng Anh"];
  congratsVC.displayingData = @{
                                kParamMessage : MMLocalizedString(@"Chúc mừng bạn đã thăng cấp"),
                                kParamSubMessage : subMessage
                                };
  
  [self presentViewController:[congratsVC parentNavigationController] animated:YES completion:NULL];
  return;
  
#if kTestSignUp
  if (_signUpVC == nil)
    _signUpVC = [MMSignUpViewController new];

  [self.navigationController pushViewController:_signUpVC animated:YES];
  [_signUpVC reloadContents];
#else
  if (_coursesListVC == nil)
    _coursesListVC = [MMCoursesListViewController new];
  
  [self.navigationController pushViewController:_coursesListVC animated:YES];
  [_coursesListVC reloadContents];
#endif
}

#pragma mark - Private methods
- (void)setupViews {
  if (DeviceScreenIsRetina4Inch())
    _imgBg.image = [UIImage imageNamed:@"Default-568h"];
  
  _btnLogIn.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogIn.layer.cornerRadius = 4;
  [_btnLogIn setTitle:MMLocalizedString(@"Log in") forState:UIControlStateNormal];
  
  _btnNewUser.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNewUser.layer.cornerRadius = 4;
  [_btnNewUser setTitle:MMLocalizedString(@"New user") forState:UIControlStateNormal];
}

- (void)test {
  TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
  label.font = [UIFont systemFontOfSize:14];
  label.textColor = [UIColor blackColor];
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.numberOfLines = 0;
//  label.delegate = self;
  
  NSString *text = @"Lorem ipsum dolar sit amet";
  label.text = text;
  [label applyWordDefinitions:@[@"Lorem", @"ipsum"] withSpecialWords:@[@"dolar"]];
  
  [label sizeToFit];
  label.center = self.view.center;
  [self.view addSubview:label];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
  DLog(@"%@", addressComponents);
}

@end
