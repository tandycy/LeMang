//
//  UserManager.m
//  LeMang
//
//  Created by LZ on 9/2/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "UserManager.h"

static UserManager* managerInstance;

@interface UserManager(prvateMethods)
-(void)realRelease;
@end


@implementation UserManager

@synthesize loginDelegate;

+ (bool) IsInitSuccess
{
    return [UserManager Instance]->initedLocalData;
}

+ (NSString*) UserName
{
    if ([UserManager IsInitSuccess])
    {
        return [UserManager Instance]->localUserName;
    }
    else
    {
        return @"";
    }
}

+ (NSString*) UserPW
{
    if ([UserManager IsInitSuccess])
    {
        return [UserManager Instance]->localPassword;
    }
    else
    {
        return @"";
    }
}

- (void)InitLocalData
{
    NSMutableDictionary* dict =  [ [ NSMutableDictionary alloc ] initWithContentsOfFile:@"/Profile.plist" ];
    localUserName = [ dict objectForKey:@"userName" ];
    
    NSData* userPw = [dict objectForKey:@"userKey"];
    localPassword = [NSData AES256Decode:userPw];
}

- (void)DoLogIn:(NSString *)name :(NSString *)pw
{
    localUserName = name;
    localPassword = pw;
    
    [self LogInCheck];
}

- (void)LogInCheck
{
    //localUserName = @"user";
    
    if (localUserName == nil)
    {
        initedLocalData = FALSE;
        [loginDelegate UserLoginContact];
        return;
    }
    
    //localPassword = @"user";
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/q?search_LIKE_loginName=";
    urlString = [urlString stringByAppendingString:localUserName];
    
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

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:localUserName password:localPassword                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (NSString*) filtStr:(NSString*)inputStr
{
    NSString* result = @"";
    
    result = [result stringByAppendingFormat:@"%@", inputStr];
    
    return result;
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
    NSArray* userData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:nil][@"content"];
    
    initedLocalData = false;
    for (int i = 0; i < userData.count; i++)
    {
        NSDictionary* data = userData[i];
        NSString* logName = data[@"loginName"];
        
        NSComparisonResult res = [logName compare:localUserName];
        
        if (res == NSOrderedSame)
        {
            NSNumber* idNum = data[@"id"];
            localUserId = [idNum integerValue];
            initedLocalData = true;
            break;
        }
    }
    
    [loginDelegate UserLoginContact];
}

- (int) GetLocalUserId
{
    return localUserId;
}

- (void) ClearLocalUserData
{
    localUserName = @"";
    localPassword = @"";
    initedLocalData = false;
    [self UpdateLocalData];
}

- (void) UpdateLocalData
{
    NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:@"/Profile.plist" ];
    
    NSData* pwData = [NSData AES256Encode:localPassword];
    
    [ dict setObject:localUserName forKey:@"userName" ];
    [ dict setObject:pwData forKey:@"userKey" ];
    
    [ dict writeToFile:@"/Profile.plist" atomically:YES ];
}

+ (UserManager*) Instance
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
            managerInstance->initedLocalData = false;
            [managerInstance InitLocalData];
            return managerInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}
/*
- (id)retain
{
    return self;
}

- (unsigned) retainCount
{
    return 1;
}

- (void) release
{
    
}

-(id) autorelease
{
    return self;
}

-(void)realRelease
{
    [super release];
}

-(void)dealloc
{
    [super dealloc];
}
 */

@end

struct UserGarbo
{
    ~UserGarbo()
    {
        [managerInstance realRelease];
    }
};
static UserGarbo userGarbo;
