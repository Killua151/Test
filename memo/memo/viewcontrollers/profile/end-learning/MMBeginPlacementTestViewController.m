//
//  FTBeginPlacementTestViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/22/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMBeginPlacementTestViewController.h"
#import "MMPlacementTestViewController.h"

@interface MMBeginPlacementTestViewController ()

@end

@implementation MMBeginPlacementTestViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  if (!DeviceScreenIsRetina4Inch()) {
    CGRect frame = _lblMessage.frame;
    frame.origin.y = DeviceSystemIsOS7() ? 30 : 20;
    _lblMessage.frame = frame;
    
    frame = _imgAnt.frame;
    frame.origin.y = _lblMessage.frame.origin.y + _lblMessage.frame.size.height + (DeviceSystemIsOS7() ? 15 : 10);
    _imgAnt.frame = frame;
    
    frame = _lblSubMessage.frame;
    frame.origin.y = _imgAnt.frame.origin.y + _imgAnt.frame.size.height +
    (DeviceSystemIsOS7() ? 15 : 10);
    _lblSubMessage.frame = frame;
  }
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _lblMessage.text = MMLocalizedString(@"Let's get started!");
  [_lblMessage adjustToFitHeight];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:14];
  _lblSubMessage.text = MMLocalizedString(@"It takes about 5 minutes, and adapts to your level by getting harder (or easier!) based on your answers.");
  [_lblSubMessage adjustToFitHeight];
  
  _btnStart.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnStart.layer.cornerRadius = 4;
  [_btnStart setTitle:MMLocalizedString(@"Start") forState:UIControlStateNormal];
  
  _btnBack.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnBack.layer.cornerRadius = 4;
  _btnBack.layer.borderColor = [UIColorFromRGB(204, 204, 204) CGColor];
  _btnBack.layer.borderWidth = 2;
  [_btnBack setTitle:MMLocalizedString(@"Back") forState:UIControlStateNormal];
}

- (IBAction)btnStartPressed:(UIButton *)sender {
  ShowHudForCurrentView();
  
  [[MMServerHelper apiHelper]
   startPlacementTest:^(NSString *examToken,
                        MBaseQuestion *question,
                        NSInteger questionNumber,
                        NSInteger totalQuestions,
                        NSError *error) {
     HideHudForCurrentView();
     ShowAlertWithError(error);
     
     MMPlacementTestViewController *placementTestVC =
     [[MMPlacementTestViewController alloc] initWithQuestions:@[question]
                                                  andMetadata:@{
                                                                kParamType : kValueExamTypePlacementTest,
                                                                kParamExamToken : [NSString normalizedString:examToken],
                                                                kParamQuestionNumber : @(questionNumber),
                                                                kParamTotalQuestions : @(totalQuestions)
                                                                }];
     
     [self presentViewController:placementTestVC animated:YES completion:NULL];
   }];
}

- (IBAction)btnBackPressed:(UIButton *)sender {
  [self dismissViewController];
}

@end
