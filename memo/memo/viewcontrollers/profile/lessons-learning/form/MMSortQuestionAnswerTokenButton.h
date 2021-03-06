//
//  FTFormAnswerTokenButton.h
//  fanto
//
//  Created by Ethan Nguyen on 9/27/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSortQuestionAnswerTokenButton : UIView {
  IBOutlet UIImageView *_imgBg;
  IBOutlet UIButton *_btnToken;
}

@property (nonatomic, assign) id<MMQuestionContentDelegate> delegate;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) FormAnswerTokenStatus status;

- (id)initWithToken:(NSString *)token;
- (IBAction)btnTokenPressed:(UIButton *)sender;

@end
