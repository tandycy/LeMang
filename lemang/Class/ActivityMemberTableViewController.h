//
//  ActivityMemberTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-12.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "Constants.h"
#import "UserManager.h"
#import "IconImageViewLoader.h"
#import "IconImageButtonLoader.h"

@interface ActivityMemberTableViewController : UITableViewController
{
    Activity* linkedActivity;
    NSMutableArray* adminList;
    NSMutableArray* memberList;
    NSMutableArray* guestList;
}

@property IBOutlet UIView *containerView;
@property IBOutlet UITableView *tbV;

- (void) SetActivity:(Activity*)activity;

@end
