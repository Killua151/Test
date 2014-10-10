//
//  MMFindFriendsViewController.m
//  memo
//
//  Created by Ethan Nguyen on 10/10/14.
//  Copyright (c) 2014 Topica. All rights reserved.
//

#import "MMFindFriendsViewController.h"
#import "MMFindFriendCell.h"
#import "MFriend.h"

@interface MMFindFriendsViewController () {
  NSMutableArray *_friendsData;
}

- (void)setupViews;
- (void)searchFriends;

@end

@implementation MMFindFriendsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupViews];
  [self reloadContents];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reloadContents {
  _friendsData = [NSMutableArray new];
  [_tblFriends reloadData];
}

- (void)gestureLayerDidTap {
  [_txtSearchFriends resignFirstResponder];
}

- (IBAction)btnClosePressed:(UIButton *)sender {
  [self dismissViewController];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  _tblFriends.scrollEnabled = [_friendsData count] > 0;
  
  if ([_friendsData count] == 0)
    return 1;
  
  return [_friendsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_friendsData count] == 0)
    return _celEmpty;
  
  MMFindFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MMFindFriendCell class])];
  
  if (cell == nil) {
    cell = [MMFindFriendCell new];
    cell.delegate = self;
  }
  
  cell.index = indexPath.row;
  [cell updateCellWithData:_friendsData[indexPath.row]];
  
  return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_friendsData count] == 0)
    return [UIScreen mainScreen].bounds.size.height - 84;
  
  return [MMFindFriendCell heightToFitWithData:_friendsData[indexPath.row]];
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self gestureLayerDidEnterEditingMode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  _vGestureLayer.hidden = YES;
  [textField resignFirstResponder];
  [self searchFriends];
  return YES;
}

#pragma mark - MMFindFriendDelegate methods
- (void)interactFriend:(NSString *)userId toFollow:(BOOL)follow atIndex:(NSInteger)index {
  MFriend *friend = _friendsData[index];
  friend.is_following = !friend.is_following;
  [_tblFriends reloadData];
}

#pragma mark - Private methods
- (void)setupViews {
  _txtSearchFriends.font = [UIFont fontWithName:@"ClearSans" size:17];
  _btnClose.titleLabel.font = [UIFont fontWithName:@"ClearSans" size:17];
  _lblEmpty.font = [UIFont fontWithName:@"ClearSans" size:17];
  _tblFriends.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
  
  if (!DeviceSystemIsOS7()) {
    CGRect frame = _tblFriends.frame;
    frame.size.height += 20;
    _tblFriends.frame = frame;
  }
}

- (void)searchFriends {
  [Utils showHUDForView:self.view withText:nil];
  
  [[MMServerHelper sharedHelper] searchFriends:_txtSearchFriends.text completion:^(NSArray *results, NSError *error) {
    [Utils hideAllHUDsForView:self.view];
    ShowAlertWithError(error);
    
    [_friendsData removeAllObjects];
    [_friendsData addObjectsFromArray:results];
    [_tblFriends reloadData];
  }];
}

@end
