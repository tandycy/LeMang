//
//  ActivityDetailTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "UserManager.h"
#import "ActivityMemberTableViewController.h"
#import "IconImageViewLoader.h"

@interface ActivityDetailTableViewController : UITableViewController
{
    NSDictionary* activityData;
    NSArray* localCommentData;
    NSNumber* localId;
    NSNumber* creatorId;
}

@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *activityDescription;
@property IBOutlet UILabel *joinState;
@property IBOutlet UILabel *hot;
@property IBOutlet UILabel *amount;
@property IBOutlet IconImageViewLoader *titleImgView;
@property IBOutlet UILabel *address;
@property IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *people;

@property (strong, nonatomic) IBOutlet UILabel *detailContent;
@property (strong, nonatomic) IBOutlet UILabel *totalMemberNum;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *memberIcon1;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *memberIcon2;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *memberIcon3;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *memberIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *rateIcon1;
@property (strong, nonatomic) IBOutlet UIImageView *rateIcon2;
@property (strong, nonatomic) IBOutlet UIImageView *rateIcon3;
@property (strong, nonatomic) IBOutlet UIImageView *rateIcon4;
@property (strong, nonatomic) IBOutlet UIImageView *rateIcon5;
@property (strong, nonatomic) IBOutlet UIImageView *rateScore1;
@property (strong, nonatomic) IBOutlet UIImageView *rateScore2;
@property (strong, nonatomic) IBOutlet UIImageView *rateScore3;
@property (strong, nonatomic) IBOutlet UIImageView *rateScore4;
@property (strong, nonatomic) IBOutlet UIImageView *rateScore5;
@property (weak, nonatomic) IBOutlet UILabel *commentTittle;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;

@property (strong, nonatomic) IBOutlet UILabel *totalCommentNumber;

- (void) SetActivityId:(NSNumber*)actid;
- (void) SetActivityData:(NSDictionary*)data;
- (void) UpdateActivityDisplay;
- (void) RefreshCommentList;
- (NSNumber*) GetCreatorId;
- (NSNumber*) GetActivityId;

@end
