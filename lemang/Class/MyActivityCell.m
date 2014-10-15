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
    
    if (canjoin)
        [self JoinCheck];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)SetAdmin
{
    [_buttonEdit setHidden:FALSE];
    [_buttonInvite setHidden:FALSE];
    
    _buttonInvite.titleLabel.text = @"邀请";
    
    caninvite = true;
    canjoin = false;
}

- (void)SetJoin
{
    [_buttonEdit setHidden:true];
    [_buttonInvite setHidden:true];
    
    caninvite = false;
    canjoin = false;
}

- (void)SetBookmark
{
    [_buttonEdit setHidden:true];
    [_buttonInvite setHidden:FALSE];
    
    caninvite = false;
    canjoin = true;
    
    _buttonInvite.titleLabel.text = @"参加";
}

- (void) JoinCheck
{
    NSNumber* localId = localData[@"id"];
    NSString* idstr = [NSString stringWithFormat:@"%@",localId];
    
    NSDictionary* idmap = [[UserManager Instance]GetGroupIdMap];
    
    NSString* str = [UserManager filtStr:idmap[idstr] :@""];
    
    if (str.length > 0)
    {
        canjoin = false;
        [_buttonInvite setHidden:true];
    }
    else
    {
        canjoin = true;
        _buttonInvite.titleLabel.text = @"参加";
    }
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
    [EditActVC SetRootView:parView];
    [parView.navigationController pushViewController:EditActVC animated:YES];
}

- (IBAction)DoActInvite:(id)sender
{
    if (caninvite)
    {
        [self DoInvite];
    }
    else if (canjoin)
    {
        [self DoJoin];
    }
}

- (void) DoInvite
{
    if (![owner isKindOfClass:[MyAcitivityTableViewController class]])
        return;
    
    MyAcitivityTableViewController* parView = (MyAcitivityTableViewController*)owner;
    
    InviteMyFriendsTableViewController *EditActVC = [parView.storyboard instantiateViewControllerWithIdentifier:@"InviteMyFriendsTableViewController"];
    
    NSNumber* aid = localData[@"id"];
    [EditActVC SetInviteActivity:aid];
    [parView.navigationController pushViewController:EditActVC animated:YES];
}

- (void) DoJoin
{
    NSNumber* aid = localData[@"id"];
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/request/activity/%@", [[UserManager Instance]GetLocalUserId], aid];

    NSURL* url = [NSURL URLWithString:urlstr];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    
    [request setUsername:[UserManager UserName]];
    [request setPassword:[UserManager UserPW]];
    
    [request addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    
    [request startSynchronous];
    
    NSError* error = [request error];
    if (!error)
    {
        int resCode = [request responseStatusCode];
        NSLog(@"regist %d",resCode);
        
        if (resCode == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"报名成功" message:@"成功提交报名申请。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alertView show];
        }
    }
}
@end
