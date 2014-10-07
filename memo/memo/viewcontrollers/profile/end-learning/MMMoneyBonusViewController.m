//
//  FTMoneyBonusViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMMoneyBonusViewController.h"
#import "MMSkillsListViewController.h"

@interface MMMoneyBonusViewController ()

@end

@implementation MMMoneyBonusViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)setupViews {
  NSString *styledString = @"2 Memos";
  NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Bạn đã được thưởng %@", nil), styledString];
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  [Utils applyAttributedTextForLabel:_lblMessage
                            withText:message
                            onString:styledString
                      withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17]}];
  [Utils adjustLabelToFitHeight:_lblMessage];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblSubMessage.text = [NSString stringWithFormat:NSLocalizedString(@"Hoàn thành kỹ năng %@", nil), @"Cơ bản 1"];
  
  _lblCount.font = [UIFont fontWithName:@"ClearSans-Bold" size:35];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
}

- (IBAction)btnNextPressed:(UIButton *)sender {
  [self transitToViewController:[MMSkillsListViewController navigationController]];
}

@end
