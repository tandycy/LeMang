//
//  SchoolManager.m
//  LeMang
//
//  Created by LZ on 9/7/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "SchoolManager.h"

static SchoolManager* managerInstance;

@interface SchoolManager(prvateMethods)
-(void)realRelease;
@end

@implementation SchoolManager

+ (SchoolManager*) Instance
{
    @synchronized (self)
    {
        if (managerInstance == nil)
        {
            [[self alloc] init];
        }
    }
    
    return managerInstance;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (managerInstance == nil)
        {
            managerInstance = [super allocWithZone:zone];
            managerInstance->isInited = false;
            return managerInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

+ (bool) IsInited
{
    return [SchoolManager Instance]->isInited;
}

- (NSArray*) getSchoolNames
{
    NSMutableArray* result = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < schoolList.count; i++)
    {
        //NSNumber* schoolId = schoolList[i][@"id"];
        NSString* name = schoolList[i][@"name"];
        [result addObject:name];
    }
        
    return result;
}

+ (NSArray*) GetSchoolNameList
{
    if (![SchoolManager IsInited])
        return [NSArray alloc];
    
    return [[SchoolManager Instance]getSchoolNames];
}

+ (NSNumber*) GetSchoolId:(NSString *)SchoolName
{
    if (![SchoolManager IsInited])
        return Nil;
    
    return [[SchoolManager Instance]getSchoolId:SchoolName];
}

- (NSNumber*) getSchoolId:(NSString*)schoolName
{
    for (int i = 0; i < schoolList.count; i++)
    {
        //NSNumber* schoolId = schoolList[i][@"id"];
        NSString* name = schoolList[i][@"name"];
        if ([name compare:schoolName])
        {
            NSNumber* schoolid =schoolList[i][@"id"];
            return schoolid;
        }
    }
    
    return 0;
}

+ (void) InitSchoolList
{
    [[SchoolManager Instance] DoInit];
}

- (void) DoInit
{
    if (isInited)
        return;
    
    [self RefreshSchoolList];
}

- (void) RefreshSchoolList
{   
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/university";
    NSURL* URL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    [URLRequest setHTTPMethod:@"GET"];
    [URLRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
    
    
    receivedData=[[NSMutableData alloc] initWithData:nil];
    
    if (connection) {
        receivedData = [NSMutableData new];
        NSLog(@"rdm%@",receivedData);
    }
}

- (void) GetSchoolArea : (NSNumber*)schoolId
{
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlString = [urlString stringByAppendingFormat:@"%d", [schoolId integerValue]];
    NSURL* URL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    [URLRequest setHTTPMethod:@"GET"];
    [URLRequest addValue:@"application/json;charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
    
    receivedData=[[NSMutableData alloc] initWithData:nil];
    
    if (connection) {
        receivedData = [NSMutableData new];
        NSLog(@"rdm%@",receivedData);
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

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)aConn didReceiveResponse:(NSURLResponse *)response

{
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        //NSLog(@"[email=dictionary=%@]dictionary=%@",[dictionary[/email] description]);
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成…");
    schoolList = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil];
    self->isInited = true;
    
    for (int i = 0; i < schoolList.count; i++)
    {
        NSString* name = schoolList[i][@"name"];
        NSNumber* schoolid =schoolList[i][@"id"];
        
        SchoolItem* newitem = [[SchoolItem alloc]init];
        
        [newitem InitSchool:name :schoolid];
        
        [schoolDic setValue:newitem forKey:name];
    }
}

@end


struct SchoolGarbo
{
    ~SchoolGarbo()
    {
        [managerInstance realRelease];
    }
};
static SchoolGarbo schoolGarbo;
