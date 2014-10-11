//
//  Friend.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "Friend.h"

@implementation Friend
{
    NSString* _category;
    NSNumber* _userId;
    NSString* _userName;
    NSString* _userSchool;
    NSString* _userCollege;
    NSString* _iconUrl;
}

@synthesize category = _category;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize userSchool = _userSchool;
@synthesize userCollege = _userCollege;
@synthesize userIconUrl = _iconUrl;

- (void)SetData:(NSDictionary *)data
{
    NSDictionary* ul = data[@"ul"];
    NSDictionary* ur = data[@"ur"];
    
    NSNumber* ulNumber = ul[@"id"];
    NSNumber* urNumber = ur[@"id"];
    
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    
    if (uid.longValue == ulNumber.longValue)
        localData = ur;
    else if (uid.longValue == urNumber.longValue)
        localData = ul;
    else
    {
        NSLog(@"User friend data erro.");
        return;
    }
    
    _userId = localData[@"id"];
    _userName = localData[@"name"];
    
    _userSchool = localData[@"university"][@"name"];
    _userCollege = localData[@"department"][@"name"];
    _iconUrl = @"";
    
    NSDictionary* profileData = localData[@"profile"];
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        NSString* nickname = [UserManager filtStr:profileData[@"nickName"] : @""];
        if (nickname.length > 0)
            _userName = nickname;
        
        NSString* urlStr = profileData[@"iconUrl"];
        _iconUrl = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
    }
}


@end
