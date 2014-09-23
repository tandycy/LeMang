//
//  MyMessageCell.h
//  LeMang
//
//  Created by LZ on 9/21/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell
{
    enum MessageCategory
    {
        CATEGORY_UNKNOWN,
        INVITATION_ASSOCIATION,
		INVITATION_ACTIVITY,
		INVITATION_FRIEND,
		ENROLLMENT_ASSOCIATION,
		ENROLLMENT_ACTIVITY,
		NOTIFICATION,
		ALERT,
		PEER
    }messCategory;
    NSMutableDictionary* enumDic;
    //
    NSDictionary* localData;
    id messageTable;
    
    NSNumber* messId;
    
    NSString* messType;
    int messState;  // 0-unread, 1-read, 2-done
    
    NSString* messTitle;
    NSString* messContent;
}

- (IBAction)OnClickDel:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *messageTitle;
@property (strong, nonatomic) IBOutlet UIImageView *messageIcon;

- (void)OnRead;
- (void)SetMessageData:(NSDictionary*)data owner:(id)owner;
- (NSNumber*)GetMessageId;

@end
