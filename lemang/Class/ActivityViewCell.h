//
//  ActivityViewCell.h
//  LeMang
//
//  Created by LZ on 8/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "UserManager.h"
#import "IconImageViewLoader.h"

@interface ActivityViewCell : UITableViewCell
{
    NSNumber* actId;
    NSDictionary* localData;
}

@property (strong, nonatomic) IBOutlet IconImageViewLoader *actIcon;
@property (strong, nonatomic) IBOutlet UILabel *actTitle;
@property (strong, nonatomic) IBOutlet UILabel *actTime;
@property (strong, nonatomic) IBOutlet UILabel *actLimit;
@property (strong, nonatomic) IBOutlet UILabel *actMember;
@property (strong, nonatomic) IBOutlet UILabel *actBookmark;
@property (strong, nonatomic) IBOutlet UIImageView *actTypeIcon;

- (void) SetActData:(NSDictionary*)data;
- (void) SetActivity:(Activity*)_act;


@end
