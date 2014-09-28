//
//  InviteFriendCell.m
//  LeMang
//
//  Created by LZ on 9/28/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "InviteFriendCell.h"
#import "InviteMyFriendsTableViewController.h";

@implementation InviteFriendCell

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

- (void)SetItem:(Friend*)friendItem
{
    localItem = friendItem;
    
    _friendName.text = localItem.userName;
    _friendCollage.text = localItem.userCollege;
    _friendSchool.text = localItem.userSchool;
    
    [_friendIcon LoadFromUrl:[NSURL URLWithString:localItem.userIconUrl] :[UserManager DefaultIcon]];
}

- (void)SetOwner:(id)_owner
{
    owner = _owner;
}

- (IBAction)DoInvite:(id)sender {
    
    if (![owner isKindOfClass:[InviteMyFriendsTableViewController class]])
        return;
    
    InviteMyFriendsTableViewController* ownerView = (InviteMyFriendsTableViewController*)owner;
    [ownerView DoInviteFriend:localItem];
}
@end
