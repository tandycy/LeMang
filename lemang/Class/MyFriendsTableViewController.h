//
//  MyFriendsTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriendCell.h"

@interface MyFriendsTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

- (void) DoRemoveFriend:(MyFriendCell*)linkedCell;

@end
