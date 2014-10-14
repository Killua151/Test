//
//  FTFinishSkillViewController.m
//  fanto
//
//  Created by Ethan Nguyen on 9/20/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "MMFinishSkillViewController.h"
#import "MMMoneyBonusViewController.h"
#import "MMShareActionSheet.h"
#import "MMSkillsListViewController.h"
#import "MUser.h"
#import "MSkill.h"

@interface MMFinishSkillViewController () {
  MMShareActionSheet *_vShare;
}

@end

@implementation MMFinishSkillViewController

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

    frame = _lblSkillName.superview.frame;
    frame.origin.y = _lblMessage.frame.origin.y + _lblMessage.frame.size.height + (DeviceSystemIsOS7() ? 15 : 10);
    _lblSkillName.superview.frame = frame;
    
    frame = _lblSubMessage.frame;
    frame.origin.y = _lblSkillName.superview.frame.origin.y + _lblSkillName.superview.frame.size.height +
    (DeviceSystemIsOS7() ? 15 : 10);
    _lblSubMessage.frame = frame;
  }
  
  MSkill *affectedSkill = [MUser currentUser].lastReceivedBonuses[kParamAffectedSkill];
  
  UIImage *maskingImage = [UIImage imageNamed:@"img-hexagon_skill-bg_big.png"];
  CALayer *maskingLayer = [CALayer layer];
  maskingLayer.frame = _vSkill.bounds;
  [maskingLayer setContents:(id)[maskingImage CGImage]];
  [_vSkill.layer setMask:maskingLayer];
  
  _vSkill.backgroundColor = [UIColor colorWithHexString:affectedSkill.theme_color];
  _lblSkillName.text = affectedSkill.title;
  _imgSkillIcon.image = [UIImage imageNamed:
                         [NSString stringWithFormat:@"img-skill_icon-%@-unlocked_big", affectedSkill._id]];
  
  NSString *styledString = _lblSkillName.text;
  NSString *message = [NSString stringWithFormat:MMLocalizedString(@"You have finished skill %@!"), styledString];
  
  _lblMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_lblMessage applyAttributedText:message
                          onString:styledString
                    withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17]}];
  [_lblMessage adjustToFitHeight];
  
  styledString = @"strength bars";
  message = [NSString stringWithFormat:MMLocalizedString(@"Keep those %@ full as words fade from your memory"), styledString];
  
  _lblSubMessage.font = [UIFont fontWithName:@"ClearSans" size:17];
  [_lblSubMessage applyAttributedText:message
                             onString:styledString
                       withAttributes:@{
                                       NSFontAttributeName : [UIFont fontWithName:@"ClearSans-Bold" size:17],
                                       NSForegroundColorAttributeName : UIColorFromRGB(255, 187, 51)
                                       }];
  [_lblSubMessage adjustToFitHeight];
  
  _btnShare.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnShare.layer.cornerRadius = 4;
  [_btnShare setTitle:MMLocalizedString(@"Share") forState:UIControlStateNormal];
  
  _btnNext.titleLabel.font = [UIFont fontWithName:@"ClearSans-Bold" size:17];
  _btnNext.layer.cornerRadius = 4;
  [_btnNext setTitle:MMLocalizedString(@"Next") forState:UIControlStateNormal];
  
  _vShare = [[MMShareActionSheet alloc] initInViewController:self];
  [self.view bringSubviewToFront:_vShare];
}

- (IBAction)btnSharePressed:(UIButton *)sender {
  [_vShare show];
}

- (IBAction)btnNextPressed:(UIButton *)sender {
  if ([MUser currentUser].lastReceivedBonuses[kParamBonusMoney] != nil)
    [self.navigationController pushViewController:[MMMoneyBonusViewController new] animated:YES];
  else
    [self transitToViewController:[MMSkillsListViewController navigationController]];
}

#pragma mark - MMActionSheetDelegate methods
- (void)actionSheetDidSelectAtIndex:(NSInteger)index {
  [self presentShareViewControllerWithDefaultOption:(ShareOption)index];
}

@end
