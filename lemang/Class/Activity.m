//
//  Activity.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-1.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "Activity.h"

@implementation Activity
@synthesize activityId;
@synthesize category;
@synthesize img;
@synthesize cachedImg;
@synthesize title;
@synthesize date;
@synthesize limit;
@synthesize icon;
@synthesize member;
@synthesize fav;
@synthesize memberUpper;

+ (id)activityOfCategory:(NSString*)category img:(NSURL*)img title:(NSString*)title date:(NSString*)date
                   limit:(NSString*)limit icon:(UIImage*)icon member:(NSString*)member memberUpper:(NSString*)memberUpper fav:(NSString*)fav state:(BOOL*)state activitiId:(long)activitiId
{
    Activity *newActivity = [[self alloc] init];
    newActivity.category = category;
    newActivity.img = img;
    newActivity.title = title;
    newActivity.date = date;
    newActivity.limit = limit;
    newActivity.member = member;
    newActivity.memberUpper = memberUpper;
    newActivity.icon = icon;
    newActivity.fav = fav;
    newActivity.state = state;
    newActivity->activityId = activitiId;
    return newActivity;
}

@end
