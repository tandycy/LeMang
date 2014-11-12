//
//  MemberInfoTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-16.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageViewLoader.h"
#include "UserManager.h"
#import "Friend.h"

@interface MemberInfoTableViewController : UITableViewController
{
    NSNumber* memberId;
    NSDictionary* localData;
    
    NSNumber* fromActId;
    NSNumber* fromOrgId;
    NSNumber* actOrgOwner;
    
    BOOL isAdmin;

    id owner;
    SEL ownerRefresh;
}

@property (strong, nonatomic) IBOutlet UILabel *departName;
@property (strong, nonatomic) IBOutlet UILabel *userNickName;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *qqNumber;
@property (strong, nonatomic) IBOutlet UILabel *wechatId;
@property (strong, nonatomic) IBOutlet UILabel *schoolName;
@property (strong, nonatomic) IBOutlet UILabel *schoolNumber;
@property (strong, nonatomic) IBOutlet UILabel *userSign;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *userGender;

@property (strong, nonatomic) IBOutlet UIButton *setAdmin;

- (void) SetMemberId :(NSNumber*)userId;
- (void) SetFromActivity :(NSNumber*)actId :(NSNumber*)owner :(BOOL)isAdmin;
- (void) SetFromGroup:(NSNumber*)gId :(NSNumber*)owner :(BOOL)isAdmin;

- (void) SetRefreshOwner :(id)target :(SEL)selecter;

- (IBAction)OnSetAdmin:(id)sender;

@end
