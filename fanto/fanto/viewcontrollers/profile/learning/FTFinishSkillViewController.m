//
//  FTFinishSkillViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTFinishSkillViewController.h"
#import "FTMoneyBonusViewController.h"

@interface FTFinishSkillViewController ()

- (void)setupViews;

@end

@implementation FTFinishSkillViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self customNavBarBgWithColor:nil];
  [self customBarButtonWithImage:nil title:@"" color:nil target:nil action:nil distance:8];
  [self setupViews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)btnSharePressed:(UIButton *)sender {
}

- (IBAction)btnNextPressed:(UIButton *)sender {
  [self.navigationController pushViewController:[FTMoneyBonusViewController new] animated:YES];
}

#pragma mark Private methods
- (void)setupViews {
  _lblSkillName.text = @"Cơ bản 1";
  
  NSString *styledString = _lblSkillName.text;
  NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Bạn đã hoàn thành kỹ năng %@!", nil), styledString];
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  [Utils applyAttributedTextForLabel:_lblMessage
                            withText:message
                            onString:styledString
                      withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17]}];
  [Utils adjustLabelToFitHeight:_lblMessage];
  
  styledString = @"strength bars";
  message = [NSString stringWithFormat:NSLocalizedString(@"Keep those %@ full as words fade from your memory", nil), styledString];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  [Utils applyAttributedTextForLabel:_lblSubMessage
                            withText:message
                            onString:styledString
                      withAttributes:@{
                                       NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17],
                                       NSForegroundColorAttributeName : UIColorFromRGB(255, 187, 51)
                                       }];
  [Utils adjustLabelToFitHeight:_lblSubMessage];
  
  _btnShare.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnShare.layer.cornerRadius = 4;
  [_btnShare setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
}

@end
