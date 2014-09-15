//
//  FTHexagonLessonView.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLesson;

@interface FTHexagonLessonView : UIView {
  IBOutlet UILabel *_lblLessonTitle;
  IBOutlet UIImageView *_imgPassed;
  IBOutlet UILabel *_lblObjectives;
  IBOutlet UIButton *_btnRetake;
}

@property (nonatomic, assign) id<FTLessonViewDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

- (id)initWithLesson:(MLesson *)lesson atIndex:(NSInteger)index forTarget:(id)target;
- (void)refreshView;
- (IBAction)btnRetakePressed:(UIButton *)sender;

@end
