//
//  AddFriendCell.m
//  LeMang
//
//  Created by LZ on 10/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "AddFriendCell.h"
#import "AddFriendViewController.h"

@implementation AddFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)OnAddFriend:(id)sender
{
    if (isUserFriend)
        return;
    
    AddFriendViewController *addVC = [owner.storyboard instantiateViewControllerWithIdentifier:@"AddFriendViewController"];
    [addVC SetData:localData];
    [owner.navigationController pushViewController:addVC animated:YES];
}

- (void)SetOwner:(UITableViewController *)_owner
{
    owner = _owner;
}

- (void)SetData:(NSDictionary*)data
{
    [self SetData:data isFriend:false];
}

- (void)SetData:(NSDictionary*)data isFriend:(bool)isFriend
{
    localData = data;
    isUserFriend = isFriend;
    
    userID = localData[@"id"];
    NSString* userName = localData[@"name"];
    
    _friendSchool.text = localData[@"university"][@"name"];
    _friendCollage.text = localData[@"department"][@"name"];
    NSString* iconUrl = @"";
    
    NSDictionary* profileData = localData[@"profile"];
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        NSString* nickname = [UserManager filtStr:profileData[@"nickName"] : @""];
        if (nickname.length > 0)
            userName = nickname;
        
        NSString* urlStr = profileData[@"iconUrl"];
        iconUrl = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
    }
    
    _friendName.text = userName;
    
    if (isFriend)
    {
        _addButton.titleLabel.text = @"已加好友";
    }
    else
        _addButton.titleLabel.text = @"加为好友";
        
    [_friendIcon LoadFromUrl:[NSURL URLWithString:iconUrl] :[UserManager DefaultIcon]];
}
@end
