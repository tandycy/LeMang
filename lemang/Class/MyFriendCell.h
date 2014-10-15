//
//  MyFriendCell.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageViewLoader.h"
#import "Friend.h"

@interface MyFriendCell : UITableViewCell
{
    Friend* localItem;
    id owner;
}

@property (strong, nonatomic) IBOutlet IconImageViewLoader *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userSchool;
@property (strong, nonatomic) IBOutlet UILabel *userCollege;

- (void) SetItem:(Friend*)friendItem :(id)_owner;
- (IBAction)OnRemoveFriend:(id)sender;
- (NSNumber*)GetFriendId;

@end
