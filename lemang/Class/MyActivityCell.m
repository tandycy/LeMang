//
//  MyActivityCell.m
//  lemang
//
//  Created by LiZheng on 9/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "MyActivityCell.h"
#import "EditActivityTableViewController.h"
#import "MyAcitivityTableViewController.h"
#import "InviteMyFriendsTableViewController.h"


@implementation MyActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)ClearData
{
    localData = nil;
    
    _actMember.text = @"";
    _actTitle.text = @"";
    
}

- (void)SetData:(NSDictionary *)data : (id)_owner;
{
    [self ClearData];
    
    if (data == nil || data == NULL)
    {
        [_buttonEdit setHidden:true];
        [_buttonInvite setHidden:true];
        return;
    }
    
    owner = _owner;
    localData = data;
    
    _actTitle.text = localData[@"title"];
    
    NSDictionary* members = localData[@"users"];
    int memberNum = 0;
    if ([members isKindOfClass:[NSDictionary class]])
    {
        memberNum = members.count;
    }
    _actMember.text = [NSString stringWithFormat:@"%d", memberNum];
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

- (IBAction)DoActEdit:(id)sender
{
    if (![owner isKindOfClass:[MyAcitivityTableViewController class]])
        return;
    
    MyAcitivityTableViewController* parView = (MyAcitivityTableViewController*)owner;
    
    EditActivityTableViewController *EditActVC = [parView.storyboard instantiateViewControllerWithIdentifier:@"EditActivityTableViewController"];
    EditActVC.navigationItem.title = @"编辑活动";
    NSNumber* aid = localData[@"id"];
    [EditActVC SetActivityDataFromId:aid];
    [parView.navigationController pushViewController:EditActVC animated:YES];
}

- (IBAction)DoActInvite:(id)sender{
}
@end
