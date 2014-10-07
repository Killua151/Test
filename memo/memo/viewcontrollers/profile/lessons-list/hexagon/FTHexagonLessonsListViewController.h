//
//  FTLessonsListViewController.h
//  fanto
//
//  Created by Ethan on 9/15/14.
//  Copyright (c) 2014 Ethan Nguyen. All rights reserved.
//

#import "FTLessonsListViewController.h"

@interface FTHexagonLessonsListViewController : FTLessonsListViewController <UIScrollViewDelegate, FTLessonViewDelegate> {
  IBOutlet UIImageView *_imgBgLaurea;
  IBOutlet UIImageView *_imgSkillIcon;
  IBOutlet UIScrollView *_vLessonsScrollView;
}

@end
