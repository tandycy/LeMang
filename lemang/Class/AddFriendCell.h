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
    
    NSNumber* userID;
}
@property (strong, nonatomic) IBOutlet IconImageViewLoader *friendIcon;
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@property (strong, nonatomic) IBOutlet UILabel *friendSchool;
@property (strong, nonatomic) IBOutlet UILabel *friendCollage;
- (IBAction)OnAddFriend:(id)sender;

- (void)SetData:(NSDictionary*)data;

@end
