//
//  Friend.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize category,userId,userName,userSchool,userCollege;

+ (id)friendOfCategory:(NSString *)category userId:(NSNumber *)userId userName:(NSString *)userName userSchool:(NSString *)userSchool userCollege:(NSString *)userCollege
{
    Friend *newFriend = [[self alloc]init];
    newFriend.category = category;
    newFriend.userId = userId;
    newFriend.userName = userName;
    newFriend.userSchool = userSchool;
    newFriend.userCollege = userCollege;
    
    return newFriend;
}

@end
