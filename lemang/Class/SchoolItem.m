//
//  SchoolItem.m
//  lemang
//
//  Created by LiZheng on 9/9/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "SchoolItem.h"

@implementation SchoolItem

- (void) InitSchool:(NSString *)name :(NSNumber *)schoolId
{
    localName = name;
    localId = schoolId;
    
    [self RefreshArea];
    [self RefreshDepart];
}

- (NSNumber*)GetId
{
    return localId;
}

- (NSNumber*) GetAreaId:(NSString *)areaName
{
    NSNumber* aid = areaDic[areaName];
    return aid;
}

- (NSNumber*) GetDepartId:(NSString *)departName
{
    NSNumber* did = departDic[departName];
    
    return did;
}

- (NSArray*) GetAreaList
{
    NSMutableArray* result = [[NSMutableArray alloc]init];
    
    for (NSString* key in areaDic)
    {
        [result addObject:key];
    }
    
    return result;
}

- (NSArray*) GetDepartList
{
    NSMutableArray* result = [[NSMutableArray alloc]init];
    
    for (NSString* key in departDic)
    {
        [result addObject:key];
    }
    
    return result;
}

- (void) RefreshArea
{
    NSString* areaString = @"http://e.taoware.com:8080/quickstart/api/v1/area/university/";
    areaString = [areaString stringByAppendingFormat:@"%@/", localId];
    NSURL* areaUrl = [NSURL URLWithString:areaString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:areaUrl];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        //NSString *response = [request responseString];
        NSData* areaData = [request responseData];
        
        NSArray* areaList = [NSJSONSerialization JSONObjectWithData:areaData options:NSJSONReadingAllowFragments error:nil];
        
        if (areaDic == nil)
            areaDic = [[NSMutableDictionary alloc]init];
        [areaDic removeAllObjects];
        
        for ( int i = 0; i < areaList.count; i++)
        {
            NSString* areaName = areaList[i][@"name"];
            NSNumber* areaId = areaList[i][@"id"];
            
            [areaDic setObject:areaId forKey:areaName];
        }
    }
}

- (void) RefreshDepart
{
    NSString* areaString = @"http://e.taoware.com:8080/quickstart/api/v1/department/university/";
    areaString = [areaString stringByAppendingFormat:@"%@/", localId];
    NSURL* areaUrl = [NSURL URLWithString:areaString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:areaUrl];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        //NSString *response = [request responseString];
        NSData* areaData = [request responseData];
        
        NSArray* areaList = [NSJSONSerialization JSONObjectWithData:areaData options:NSJSONReadingAllowFragments error:nil];
        
        if (departDic == nil)
            departDic = [[NSMutableDictionary alloc]init];
        [departDic removeAllObjects];
        
        for ( int i = 0; i < areaList.count; i++)
        {
            NSString* departName = areaList[i][@"name"];
            NSNumber* areaId = areaList[i][@"id"];
            
            [departDic setObject:areaId forKey:departName];
        }
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:@"user" password:@"user"                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

@end
