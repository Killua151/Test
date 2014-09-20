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

@end

@implementation FTFinishSkillViewController

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

- (IBAction)btnSharePressed:(UIButton *)sender {
}

- (IBAction)btnNextPressed:(UIButton *)sender {
  [self.navigationController pushViewController:[FTMoneyBonusViewController new] animated:YES];
}

@end
