//
//  MyFriendCell.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyFriendCell.h"

@implementation MyFriendCell
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

- (void)SetItem:(id)friendItem
{
    localItem = friendItem;
    
    _userName.text = localItem.userName;
    _userCollege.text = localItem.userCollege;
    _userSchool.text = localItem.userSchool;
    
    [_userIcon LoadFromUrl:[NSURL URLWithString:localItem.userIconUrl] :[UserManager DefaultIcon]];
}

@end
