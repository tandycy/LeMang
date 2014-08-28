//
//  ActivityDetailTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ActivityDetailTableViewController : UITableViewController
{
    Activity *activity;
    UILabel *titleLabel;
    UILabel *activityDescription;
    UILabel *joinState;
    UILabel *hot;
    UILabel *amount;
    UIImageView *titleImgView;
    UILabel *address;
    UILabel *time;
    
    NSMutableData* receivedData;
    NSDictionary* activityData;
}

@property (nonatomic, retain) Activity *activity;
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *activityDescription;
@property IBOutlet UILabel *joinState;
@property IBOutlet UILabel *hot;
@property IBOutlet UILabel *amount;
@property IBOutlet UIImageView *titleImgView;
@property IBOutlet UILabel *address;
@property IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *detailContent;

- (void) refreshActivityDetail;

@end
