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
@synthesize name;
@synthesize icon;

+ (id)activityOfCategory:(NSString *)category name:(NSString *)name icon:(UIImage *)icon
{         Activity *newActivity = [[self alloc] init];
    newActivity.category = category;
    newActivity.name = name;
    newActivity.icon = icon;
    return newActivity;
}

@end
