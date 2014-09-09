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
    NSString* areaString = @"http://e.taoware.com:8080/quickstart/api/v1/area/university/";
    areaString = [areaString stringByAppendingFormat:@"%@/", localId];
    NSURL* areaUrl = [NSURL URLWithString:areaString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:areaUrl];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
    //[request setDomain:@"e.taoware.com"];
    //[request setAuthenticationScheme:(NSString*)kCFHTTPAuthenticationSchemeBasic];
    //[request addBasicAuthenticationHeaderWithUsername:@"admin" andPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        //NSString *response = [request responseString];
        NSArray* areaData = [request responseData];
        
        NSString* resStr = [request responseString];
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

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
}
@end
