//
//  InviteMyFriendsTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-25.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IconImageViewLoader.h"
#import "Friend.h"

@interface InviteMyFriendsTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>
{
    enum InviteType
    {
        Unknown,
        Activity,
        Group,
    }inviteType;
    
    NSNumber* inviteId;
}

- (void)DoInviteFriend:(Friend*)friendItem;
- (void)SetInviteActivity:(NSNumber*)aid;
- (void)SetInviteGroup:(NSNumber*)gid;

@end
