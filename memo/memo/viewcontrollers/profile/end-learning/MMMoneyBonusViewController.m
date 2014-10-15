//
//  FTMoneyBonusViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMMoneyBonusViewController.h"
#import "MMSkillsListViewController.h"
#import "MUser.h"
#import "MSkill.h"

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
  NSDictionary *receivedBonuses = [MUser currentUser].lastReceivedBonuses;
  MSkill *affectedSkill = receivedBonuses[kParamAffectedSkill];
  NSInteger bonusMoney = [receivedBonuses[kParamBonusMoney] integerValue];
  
  NSString *styledString = [NSString stringWithFormat:MMLocalizedString(@"%ld Memo Coin"), (long)bonusMoney];
  NSString *message = [NSString stringWithFormat:MMLocalizedString(@"You are bonused %@"), styledString];
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_lblMessage applyAttributedText:message
                          onString:styledString
                    withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17]}];
  [_lblMessage adjustToFitHeight];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblSubMessage.text = [NSString stringWithFormat:MMLocalizedString(@"Finish skill %@"), affectedSkill.title];
  
  _lblCount.font = [UIFont fontWithName:@"ClearSans-Bold" size:35];
  _lblCount.text = [NSString stringWithFormat:@"%ld", (long)bonusMoney];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:MMLocalizedString(@"Next") forState:UIControlStateNormal];
}

- (IBAction)btnNextPressed:(UIButton *)sender {
  [self transitToViewController:[MMSkillsListViewController navigationController]];
}

@end
