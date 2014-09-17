//
//  UserInfoTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#include "IconImageViewLoader.h"

@interface UserInfoTableViewController : UITableViewController
{
    UIImagePickerController *imagePicker;
    UIImage* image;
    NSNumber* userId;
}
- (IBAction)OnChangeIcon:(id)sender;
- (void)UpdateContentDisplay;

@property (strong, nonatomic) IBOutlet IconImageViewLoader *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userNickName;
@property (strong, nonatomic) IBOutlet UILabel *userSign;
@property (strong, nonatomic) IBOutlet UILabel *schoolNumber;
@property (strong, nonatomic) IBOutlet UILabel *schoolName;
@property (strong, nonatomic) IBOutlet UILabel *departName;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *qqNumber;
@property (strong, nonatomic) IBOutlet UILabel *wechatId;

@end
