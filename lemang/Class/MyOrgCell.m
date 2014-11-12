//
//  MyOrgCell.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyOrgCell.h"
#import "MyOrganizationTableViewController.h"
#import "EditOrganizationTableViewController.h"
#import "InviteMyFriendsTableViewController.h"
#import "Constants.h"

@implementation MyOrgCell

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

- (void)ClearData
{
    localData = nil;
    
    _orgMember.text = @"";
    _orgTitle.text = @"";
    
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
    
    _orgTitle.text = localData[@"name"];
    
    NSDictionary* members = localData[@"users"];
    int memberNum = 0;
    if ([members isKindOfClass:[NSDictionary class]])
    {
        memberNum = members.count;
    }
    _orgMember.text = [NSString stringWithFormat:@"%d", memberNum];
    
    if (canjoin)
        [self JoinCheck];
}

- (void)SetAdmin
{
    [_buttonEdit setHidden:FALSE];
    [_buttonInvite setHidden:FALSE];
    
    _buttonInvite.titleLabel.text = @"邀请";
    _buttonInvite.titleLabel.textColor = defaultMainColor;
    
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
    [_buttonInvite setHidden:true];
    
    caninvite = false;
    canjoin = true;
    
    _buttonInvite.titleLabel.text = @"参加";
    _buttonInvite.titleLabel.textColor = defaultMainColor;
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
        [_buttonInvite setHidden:false];
        _buttonInvite.titleLabel.text = @"参加";
        _buttonInvite.titleLabel.textColor = defaultMainColor;
    }
}

-(IBAction)DoOrgEdit:(id)sender
{
    if (![owner isKindOfClass:[MyOrganizationTableViewController class]])
        return;
    
    MyOrganizationTableViewController* parView = (MyOrganizationTableViewController*)owner;
    
    EditOrganizationTableViewController *EditOrgVC = [parView.storyboard instantiateViewControllerWithIdentifier:@"EditOrganizationTableViewController"];
    EditOrgVC.navigationItem.title = @"编辑组织";
    NSNumber* orgId = localData[@"id"];
    [EditOrgVC SetOrganizationDataFromId:orgId];
    [EditOrgVC SetRootView:parView];
    [parView.navigationController pushViewController:EditOrgVC animated:YES];
}

- (IBAction)DoOrgInvite:(id)sender
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

- (void)DoInvite
{
    if (![owner isKindOfClass:[MyOrganizationTableViewController class]])
        return;
    
    MyOrganizationTableViewController* parView = (MyOrganizationTableViewController*)owner;
    
    InviteMyFriendsTableViewController *EditActVC = [parView.storyboard instantiateViewControllerWithIdentifier:@"InviteMyFriendsTableViewController"];
    
    NSNumber* oid = localData[@"id"];
    [EditActVC SetInviteGroup:oid];
    [parView.navigationController pushViewController:EditActVC animated:YES];
}

- (void) DoJoin
{
    NSNumber* orgId = localData[@"id"];
    
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/request/association/%@", [[UserManager Instance]GetLocalUserId], orgId];
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
        // TODO
        int resCode = [request responseStatusCode];
        NSLog(@"regist %d",resCode);
        
        if (resCode == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"报名成功" message:@"成功提交报名申请。" delegate:Nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alertView show];
        }
    }

}

@end
