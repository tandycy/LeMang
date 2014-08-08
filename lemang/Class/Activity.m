//
//  Activity.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-1.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "Activity.h"

@implementation Activity

@synthesize category;
@synthesize img;
@synthesize title;
@synthesize date;
@synthesize limit;
@synthesize icon;
@synthesize member;
@synthesize fav;

+ (id)activityOfCategory:(NSString*)category img:(UIImage*)img title:(NSString*)title date:(NSString*)date
limit:(NSString*)limit icon:(UIImage*)icon member:(NSString*)member fav:(NSString*)fav
{
    Activity *newActivity = [[self alloc] init];
    newActivity.category = category;
    newActivity.img = img;
    newActivity.title = title;
    newActivity.date = date;
    newActivity.limit = limit;
    newActivity.member = member;
    newActivity.icon = icon;
    newActivity.fav = fav;
    return newActivity;
}

@end
