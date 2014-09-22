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

- (void)SetMessageData:(NSDictionary *)data owner:(id)owner
{
    localData = data;
    messageTable = owner;
    
    messType = localData[@"type"];
    messId = localData[@"id"];
    messCategory = localData[@"category"];
    
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
        _messageIcon.image = [UIImage imageNamed:@"mess_2"];
    }
    else
    {
        // should not happen
        messState = -1;
    }
    
    _messageTitle.text = localData[@"title"];
    messContent = [UserManager filtStr : localData[@"content"] : @""];
    /*
     association
     from
     content
     to
     activity
     */
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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_messageTitle.text message:messContent delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    [alertView show];
    return;
}

@end
