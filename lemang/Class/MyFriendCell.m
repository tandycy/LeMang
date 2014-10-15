//
//  MyFriendCell.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyFriendCell.h"
#import "MyFriendsTableViewController.h"

@implementation MyFriendCell
{
    UIAlertView* confirmView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)SetItem:(id)friendItem : (id)_owner
{
    owner = _owner;
    localItem = friendItem;
    
    _userName.text = localItem.userName;
    _userCollege.text = localItem.userCollege;
    _userSchool.text = localItem.userSchool;
    
    [_userIcon LoadFromUrl:[NSURL URLWithString:localItem.userIconUrl] :[UserManager DefaultIcon]];
}

- (NSNumber*)GetFriendId
{
    return localItem.userId;
}

- (IBAction)OnRemoveFriend:(id)sender
{
    NSString* messContent = [NSString stringWithFormat:@"是否确定删除好友：%@",localItem.userName];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"删除好友" message:messContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
    confirmView = alertView;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView != confirmView)
        return;
    
    if (buttonIndex == 1)
    {
        if ([owner isKindOfClass:[MyFriendsTableViewController class]])
        {
            [(MyFriendsTableViewController*)owner DoRemoveFriend:self];
        }
    }
}

@end
