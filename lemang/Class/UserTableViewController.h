//
//  UserTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageViewLoader.h"
//#import "UserManager.h"
#import "SchoolManager.h"
#import "UserLoginViewController.h"
#import "Base64.h"

#import "AsiHttpRequest/Classes/ASIHTTPRequest.h"

@interface UserTableViewController : UITableViewController
{
    NSMutableData *receivedData;
    NSDictionary* userData;
    UserLoginViewController* ULVC;
}
@property (strong, nonatomic) IBOutlet UILabel *userNameText;
@property (strong, nonatomic) IBOutlet UILabel *userGenderText;
@property (strong, nonatomic) IBOutlet UILabel *userSchoolText;
@property (strong, nonatomic) IBOutlet UILabel *userDescText;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *userIconImageLoader;

@property (strong, nonatomic) IBOutlet UIButton *rankButton;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;
@property (strong, nonatomic) IBOutlet UIButton *mobilePhoneButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) IBOutlet UITableViewCell *accCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myOrgCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myActCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *myFriendsCell;

@property (strong, nonatomic) IBOutlet UIButton *messageButton;

- (IBAction)DoLogOut:(id)sender;
- (void) refreshUserData;

@end
