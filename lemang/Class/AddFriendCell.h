//
//  AddFriendCell.h
//  LeMang
//
//  Created by LZ on 10/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IconImageViewLoader.h"

@interface AddFriendCell : UITableViewCell
{
    NSDictionary* localData;
    bool isUserFriend;
    
    UITableViewController* owner;
    
    NSNumber* userID;
}
@property (strong, nonatomic) IBOutlet IconImageViewLoader *friendIcon;
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@property (strong, nonatomic) IBOutlet UILabel *friendSchool;
@property (strong, nonatomic) IBOutlet UILabel *friendCollage;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)OnAddFriend:(id)sender;

- (void)SetOwner:(UITableViewController*)_owner;
- (void)SetData:(NSDictionary*)data;
- (void)SetData:(NSDictionary*)data isFriend:(bool)isFriend;

@end
