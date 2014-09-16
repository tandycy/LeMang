//
//  MemberInfoTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-16.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageViewLoader.h"

@interface MemberInfoTableViewController : UITableViewController

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

- (void) SetMemberId:(NSNumber*)userId;

@end
