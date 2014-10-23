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
#import <FacebookSDK/FacebookSDK.h>

#define kSlideAnimationDelay          5

@interface MMHomeViewController () {
  MMLoginViewController *_loginVC;
  MMSignUpViewController *_signUpVC;
  MMCoursesListViewController *_coursesListVC;
}

- (void)setupViews;
- (void)animateSlideView;

@end

@implementation MMHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customTitleWithText:@"" color:[UIColor clearColor]];
  
#if kBuildForApple
  [Utils logAnalyticsForScreen:kValueNewInstallApple];
#else
  [Utils logAnalyticsForScreen:kValueNewInstallAppota];
#endif
  [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_vSlide refreshCustomScrollIndicators];
  [self performSelector:@selector(animateSlideView) withObject:nil afterDelay:kSlideAnimationDelay];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_vSlide disableCustomScrollIndicator];
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  _loginVC = nil;
  _signUpVC = nil;
  _coursesListVC = nil;
}

- (IBAction)btnLoginPressed:(UIButton *)sender {
  [Utils logAnalyticsForButton:@"New user"];
  
  if (_loginVC == nil)
    _loginVC = [MMLoginViewController new];
  
  [self.navigationController pushViewController:_loginVC animated:YES];
  [_loginVC reloadContents];
}

- (IBAction)btnNewUserPressed:(UIButton *)sender {
  [Utils logAnalyticsForButton:@"New user"];
  
#if kTempDisableForClosedBeta
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

#pragma mark - UIScrollViewDelgate methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [Utils logAnalyticsForScrollingOnScreen:NSStringFromClass([self class]) toOffset:scrollView.contentOffset];
}

#pragma mark - Private methods
- (void)setupViews {
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _vSlide.frame;
    frame.origin.y += 77;
    frame.size.height -= 88;
    _vSlide.frame = frame;
  }
  
  _vSlide.contentSize = CGSizeMake(_vSlide.frame.size.width * 4, _vSlide.contentSize.height);
  
  if (!DeviceSystemIsOS8())
    [_vSlide enableCustomScrollIndicatorsWithScrollIndicatorType:JMOScrollIndicatorTypePageControl
                                                       positions:JMOHorizontalScrollIndicatorPositionBottom
                                                           color:UIColorFromRGB(129, 12, 21)];
  
  for (NSInteger i = 1; i <= 4; i++) {
    CGRect frame = _vSlide.frame;
    frame.origin.x = (i-1)*_vSlide.frame.size.width;
    frame.origin.y = 0;
    UIView *vSlideImage = [[UIView alloc] initWithFrame:frame];
    vSlideImage.backgroundColor = [UIColor clearColor];
    vSlideImage.clipsToBounds = YES;
    
    UIImageView *imgSlide = [[UIImageView alloc] initWithImage:
                             [UIImage imageNamed:[NSString stringWithFormat:@"img-home_slide-%ld.png", (long)i]]];
    imgSlide.contentMode = UIViewContentModeScaleAspectFit;
    frame = imgSlide.frame;
    frame.size = vSlideImage.frame.size;
    imgSlide.frame = frame;
    [vSlideImage addSubview:imgSlide];
    
    [_vSlide addSubview:vSlideImage];
  }
  
  _lblVersion.font = [UIFont fontWithName:@"ClearSans" size:14];
  _lblVersion.text = [NSString stringWithFormat:@"Beta v%@", CurrentBuildVersion()];
  
  _btnLogIn.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnLogIn.layer.cornerRadius = 4;
  [_btnLogIn setTitle:MMLocalizedString(@"Log in") forState:UIControlStateNormal];
  
  _btnNewUser.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNewUser.layer.cornerRadius = 4;
  [_btnNewUser setTitle:MMLocalizedString(@"New user") forState:UIControlStateNormal];
}

- (void)animateSlideView {
  CGPoint contentOffset = _vSlide.contentOffset;
  NSInteger currentPage = contentOffset.x / _vSlide.frame.size.width;
  currentPage = (currentPage + 1) % 4;
  contentOffset.x = currentPage*_vSlide.frame.size.width;
  [_vSlide setContentOffset:contentOffset animated:YES];
  
  [self performSelector:@selector(animateSlideView) withObject:nil afterDelay:kSlideAnimationDelay];
}

@end
