//
//  MyMessageCell.m
//  LeMang
//
//  Created by LZ on 9/21/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "MyMessageCell.h"
#import "MyMessageTableViewController.h"

@implementation MyMessageCell

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

- (IBAction)OnClickDel:(id)sender {
    if (messageTable && [messageTable isKindOfClass:[MyMessageTableViewController class]])
    {
        [(MyMessageTableViewController*)messageTable OnMessageDelete:self];
    }
}

- (void)ParseCategory
{
    NSString* catg = localData[@"category"];
    
    if ([catg isEqualToString:@"INVITATION_ASSOCIATION"])
        messCategory = INVITATION_ASSOCIATION;
    else if ([catg isEqualToString:@"INVITATION_ACTIVITY"])
        messCategory = INVITATION_ACTIVITY;
    else if ([catg isEqualToString:@"INVITATION_FRIEND"])
        messCategory = INVITATION_FRIEND;
    else if ([catg isEqualToString:@"ENROLLMENT_ASSOCIATION"])
        messCategory = ENROLLMENT_ASSOCIATION;
    else if ([catg isEqualToString:@"ENROLLMENT_ACTIVITY"])
        messCategory = ENROLLMENT_ACTIVITY;
    else if ([catg isEqualToString:@"NOTIFICATION"])
        messCategory = NOTIFICATION;
    else if ([catg isEqualToString:@"ALERT"])
        messCategory = ALERT;
    else if ([catg isEqualToString:@"PEER"])
        messCategory = PEER;
    else
    {
        messCategory = CATEGORY_UNKNOWN;
        NSString* errorMessage = @"Unknown message category: ";
        errorMessage = [errorMessage stringByAppendingFormat:@"%@", catg];
        NSLog(@"%@",errorMessage);
        return;
    }
}

- (void)ParseMessageContent
{
    NSDictionary* groupData = localData[@"association"];
    NSDictionary* senderData = localData[@"from"];
    NSDictionary* activityData = localData[@"activity"];
    
    switch (messCategory) {
        case INVITATION_ASSOCIATION:
        {
            if (![groupData isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Missing group data for INVITATION_ASSOCIATION message.");
                return;
            }
            NSString* nameStr = [UserManager filtStr: groupData[@"name"]];
            messTitle = @"收到组织邀请";
            messContent = [NSString stringWithFormat:@"收到组织<%@>的邀请\n是否加入该组织？",nameStr];
        }
            break;
        case INVITATION_ACTIVITY:
        {
            if (![activityData isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Missing activity data for INVITATION_ACTIVITY message.");
                return;
            }
            NSString* nameStr = [UserManager filtStr: activityData[@"title"]];
            messTitle = @"收到活动邀请";
            messContent = [NSString stringWithFormat:@"收到活动<%@>的邀请\n是否参加该活动？",nameStr];
        }
            break;
        case INVITATION_FRIEND:
        {
            if (![senderData isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Missing sender data for INVITATION_FRIEND message.");
                return;
            }
            NSString* nameStr = [UserManager filtStr: senderData[@"name"]];
            messTitle = @"收到好友邀请";
            messContent = [NSString stringWithFormat:@"收到<%@>的好友邀请\n是否同意？",nameStr];
        }
            break;
        case ENROLLMENT_ASSOCIATION:
        {
            if (![groupData isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Missing group data for ENROLLMENT_ASSOCIATION message.");
                return;
            }
            if (![senderData isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Missing sender data for ENROLLMENT_ASSOCIATION message.");
                return;
            }
            NSString* groupName = [UserManager filtStr: groupData[@"name"]];
            NSString* senderName = [UserManager filtStr: senderData[@"name"]];
            messTitle = @"收到组织加入请求";
            messContent = [NSString stringWithFormat:@"<%@>申请加入组织<%@>\n是否同意？",senderName,groupName];
        }
            break;
        case ENROLLMENT_ACTIVITY:
        {
            if (![activityData isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Missing activity data for ENROLLMENT_ACTIVITY message.");
                return;
            }
            if (![senderData isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Missing sender data for ENROLLMENT_ACTIVITY message.");
                return;
            }
            NSString* activityName = [UserManager filtStr: activityData[@"title"]];
            NSString* senderName = [UserManager filtStr: senderData[@"name"]];
            messTitle = @"收到活动参加请求";
            messContent = [NSString stringWithFormat:@"<%@>申请参加活动<%@>\n是否同意？",senderName,activityName];
        }
            break;
        case NOTIFICATION:
        {
             messTitle = @"收到提醒";
        }
            break;
        case ALERT:
        {
             messTitle = @"收到警告";
        }
            break;
        case PEER:
        {
             messTitle = @"收到关注";
        }
            break;
        default:
        {
            //
        }
            break;
    }

}

- (void)ParseMessageState
{
    NSString* state = localData[@"status"];
    if ([state isEqualToString:@"UNREAD"])
    {
        messState = 0;
        _messageIcon.image = [UIImage imageNamed:@"mess_1"];
    }
    else if ([state isEqualToString:@"READ"])
    {
        messState = 1;
        _messageIcon.image = [UIImage imageNamed:@"mess_2"];
    }
    else if ([state isEqualToString:@"DONE"])
    {
        messState = 2;
        _messageIcon.image = [UIImage imageNamed:@"yes"];
    }
    else
    {
        // should not happen
        messState = -1;
    }

}

- (void)SetMessageData:(NSDictionary *)data owner:(id)owner
{
   //key: id category association from content status to activity title
     
    localData = data;
    messageTable = owner;
    messCategory = CATEGORY_UNKNOWN;
    
    messTitle = @"";
    messContent = @"";
    
    messType = localData[@"type"];
    messId = localData[@"id"];
    
    [self ParseCategory];
    [self ParseMessageContent];
    
    [self ParseMessageState];
    
    _messageTitle.text = messTitle;
}

- (NSNumber*)GetMessageId
{
    return messId;
}

- (void)OnRead
{
    if (messState == 0)
    {
        [_messageIcon setImage:[UIImage imageNamed:@"mess_2"]];
        messState = 1;
        
        NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/read/";
        urlString = [urlString stringByAppendingFormat:@"%@", messId];
        
        ASIHTTPRequest* readRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        [readRequest setRequestMethod:@"PUT"];
        [readRequest startSynchronous];
    }
    
    UIAlertView *alertView;
    
    if (messState == 2)
    {
        alertView = [[UIAlertView alloc] initWithTitle:messTitle message:messContent delegate:self cancelButtonTitle:@"已完成" otherButtonTitles: nil];
    }
    else if (messCategory == NOTIFICATION || messCategory == ALERT || messCategory == PEER)
    {
        alertView = [[UIAlertView alloc] initWithTitle:messTitle message:messContent delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:messTitle message:messContent delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", @"拒绝", nil];
    }
    
    [alertView show];
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
    {
        // reject
        NSString* rejectStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/reject/";
        rejectStr = [rejectStr stringByAppendingFormat:@"%@",messId];
        
        ASIHTTPRequest* rejectRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:rejectStr]];
        [rejectRequest setRequestMethod:@"PUT"];
        [rejectRequest startSynchronous];
        
        NSError* error = [rejectRequest error];
        
        if (error)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"操作失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"已完成", nil];
            [alertView show];
            return;
        }
        
        if([rejectRequest responseStatusCode] == 200)
        {
            messState = 2;  // set state done
            _messageIcon.image = [UIImage imageNamed:@"yes"];
        }
    }
    else if (buttonIndex == 1)
    {
        // accept
        NSString* acceptStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
        int uid = [[UserManager Instance]GetLocalUserId];
        
        if (messCategory == INVITATION_ASSOCIATION)
            acceptStr = [acceptStr stringByAppendingFormat:@"accept/association/%@",messId];
        else if (messCategory == INVITATION_ACTIVITY)
            acceptStr = [acceptStr stringByAppendingFormat:@"accept/activity/%@", messId];
        else if (messCategory == ENROLLMENT_ASSOCIATION)
            acceptStr = [acceptStr stringByAppendingFormat:@"%d/approve/association/%@", uid, messId];
        else if (messCategory == ENROLLMENT_ACTIVITY)
            acceptStr = [acceptStr stringByAppendingFormat:@"%d/approve/activity/%@", uid, messId];
        else if (messCategory == INVITATION_FRIEND)
        {
            @try {
                NSDictionary* senderData = localData[@"from"];
                NSNumber* fromId = senderData[@"id"];
                acceptStr = [acceptStr stringByAppendingFormat:@"%d/friend/%@", uid, fromId];
            }
            @catch (NSException *exception) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"操作失败" message:@"消息数据错误" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
                [alertView show];
                return;
            }
        }
        else
        {
            NSLog(@"Unknown message category for accept action");
            return;
        }
        
        ASIHTTPRequest* acceptRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:acceptStr]];
        
        if (messCategory == INVITATION_FRIEND)
            [acceptRequest setRequestMethod:@"PUT"];
        else
            [acceptRequest setRequestMethod:@"POST"];
        [acceptRequest startSynchronous];
        
        NSError* error = [acceptRequest error];
        
        if (error)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"操作失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        if([acceptRequest responseStatusCode] == 200)
        {
            messState = 2;  // set state done
            _messageIcon.image = [UIImage imageNamed:@"yes"];
        }
    }
    else if (buttonIndex == 0)
    {
        // cancel - no operation here
    }
}

@end
