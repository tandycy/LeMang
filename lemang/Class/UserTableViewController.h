//
//  UserTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageViewLoader.h"
#import "UserManager.h"

@interface UserTableViewController : UITableViewController
{
    NSMutableData *receivedData;
    NSDictionary* userData;
}
@property (strong, nonatomic) IBOutlet UILabel *userNameText;
@property (strong, nonatomic) IBOutlet UILabel *userGenderText;
@property (strong, nonatomic) IBOutlet UILabel *userSchoolText;
@property (strong, nonatomic) IBOutlet UILabel *userDescText;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *userIconImageLoader;

@end
