//
//  InviteFriendCell.h
//  LeMang
//
//  Created by LZ on 9/28/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageViewLoader.h"
#import "Friend.h"

@interface InviteFriendCell : UITableViewCell
{
    Friend* localItem;
    id owner;
}

@property (strong, nonatomic) IBOutlet IconImageViewLoader *friendIcon;
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@property (strong, nonatomic) IBOutlet UILabel *friendSchool;
@property (strong, nonatomic) IBOutlet UILabel *friendCollage;

- (IBAction)DoInvite:(id)sender;
- (void) SetItem:(Friend*)friendItem;
- (void) SetOwner:(id)_owner;

@end
