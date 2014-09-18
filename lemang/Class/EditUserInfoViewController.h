//
//  EditUserInfoViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-17.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoTableViewController.h"

@interface EditUserInfoViewController : UIViewController
{
    NSString* userKey;
    NSNumber* uid;
    NSString* defaultV;
    
    int itemType;
    
    NSDictionary* originData;
    
    UserInfoTableViewController* owner;
}

@property (strong,nonatomic) UITextView *editText;

- (void) SetEditProfile : (NSString*)itemKey  userId:(NSNumber*)userId  defaultValue:(NSString*)defaultValue;
- (void) SetEditContact : (NSString*)itemKey  userId:(NSNumber*)userId  defaultValue:(NSString*)defaultValue;
- (void) SetOriginData : (NSDictionary*)data;
- (void) SetOwner : (UserInfoTableViewController*)_owner;

@end
