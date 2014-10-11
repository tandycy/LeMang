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

+ (bool) IsTestVersion
{
    // ONLY RETURN TRUE FOR TEST VERSION !!!
    return true;
}

+ (bool) IsInitSuccess
{
    return [UserManager Instance]->initedLocalData;
}

+ (bool) IsUserAuthen
{
    return [UserManager Instance]->isCertify;
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

+ (NSString*) UserNick
{
    if ([UserManager IsInitSuccess])
    {
        return [UserManager Instance]->localNickName;
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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"profile" ofType:@"plist"];
    NSLog(@"load path: %@", plistPath);
    NSMutableDictionary* dict =  [ [ NSMutableDictionary alloc ] initWithContentsOfFile:plistPath];
    localUserName = [ dict objectForKey:@"userName" ];
    localNickName = localUserName;
    
    NSData* userPw = [dict objectForKey:@"userKey"];
    localPassword = [NSData AES256Decode:userPw];
}

- (void)DoLogIn:(NSString *)name :(NSString *)pw
{
    localUserName = name;
    localNickName = name;
    localPassword = pw;
    
    [self LogInCheck];
}

+ (bool) IsUserNameExists:(NSString *)nameData
{
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/q?search_LIKE_loginName=";
    urlString = [urlString stringByAppendingString:nameData];
    
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        
        NSData* loginData = [request responseData];
        NSArray* userData = [NSJSONSerialization JSONObjectWithData:loginData options:NSJSONReadingAllowFragments error:nil][@"content"];

        for (int i = 0; i < userData.count; i++)
        {
            NSDictionary* data = userData[i];
            NSString* logName = data[@"loginName"];
            
            NSComparisonResult res = [logName compare:nameData];
            
            if (res == NSOrderedSame)
            {
                return true;
            }
        }
    }
    return false;
}

+ (UIImage*) DefaultIcon
{
    if ([UserManager Instance]->defaultIcon == nil)
        [UserManager Instance]->defaultIcon = [UIImage imageNamed:@"user_icon_de.png"];
    
    return [UserManager Instance]->defaultIcon;
}

+ (NSDictionary*) LocalUserData
{
    if ([UserManager IsInitSuccess])
    {
        return [UserManager Instance]->localUserData;
    }
    else
    {
        return nil;
    }
}

+ (void) RefreshUserData
{
    if ([UserManager IsInitSuccess])
        [[UserManager Instance] RefreshData];
}

+ (void) SetDirty
{
    [UserManager Instance]->isdirty = true;
}

+ (void) SetClear
{
    [UserManager Instance]->isdirty = false;
}

+ (bool) IsDirty
{
    return [UserManager Instance]->isdirty;
}

- (void) RefreshData
{
    if (!initedLocalData)
        return;
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlString = [urlString stringByAppendingFormat:@"%d", localUserId];
    NSURL* URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSDictionary* userData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
        
        if (userData == nil)
            return;
        
        if (![userData isKindOfClass:NSDictionary.class])
            return;
        
        localUserData = userData;
        
        [self UpdateUserProfile];
        
        [UserManager SetDirty];
    }
}

- (void)LogInCheck
{
    
    initedLocalData = FALSE;
    
    if (localUserName == nil)
    {
        [loginDelegate UserLoginContact:0];
        return;
    }
    
    NSString* urlString = @"http://e.taoware.com:8080/quickstart/api/v1/user/q?search_LIKE_loginName=";
    urlString = [urlString stringByAppendingString:localUserName];
    
    NSURL* URL = [NSURL URLWithString:urlString];
    
    [ASIHTTPRequest clearSession];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:localUserName];
    [request setPassword:localPassword];
    
    [request setAuthenticationScheme:(NSString*)kCFHTTPAuthenticationSchemeBasic];
    request.shouldPresentCredentialsBeforeChallenge = YES;
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
        
        NSData* loginData = [request responseData];
        
        NSArray* userData = [NSJSONSerialization JSONObjectWithData:loginData options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        initedLocalData = false;
        for (int i = 0; i < userData.count; i++)
        {
            NSDictionary* data = userData[i];
            NSString* logName = data[@"loginName"];
            
            NSComparisonResult res = [logName compare:localUserName];
            
            if (res == NSOrderedSame)
            {
                localUserId = data[@"id"];
                localUserData = data;
                
                [self UpdateUserProfile];
                
                initedLocalData = true;
                [self UpdateLocalData];
                break;
            }
        }
    }
    
    [loginDelegate UserLoginContact : [request responseStatusCode]];
}

- (void) UpdateUserProfile
{
    NSDictionary* profileData = localUserData[@"profile"];
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        NSString* nickname = [UserManager filtStr:profileData[@"nickName"] : @""];
        if (nickname.length > 0)
            localNickName = nickname;
    }
    
    NSDictionary* auth = localUserData[@"authentication"];
    if ([auth isKindOfClass:[NSDictionary class]])
    {
        // TODO
        isCertify = true;
    }
}

- (void) SetAuthen
{
    isCertify = true;
}

- (NSNumber*) GetLocalUserId
{
    return localUserId;
}

- (void) ClearLocalUserData
{
    localUserName = @"";
    localPassword = @"";
    localNickName = @"";
    initedLocalData = false;
    isCertify = false;
    [self UpdateLocalData];
    [UserManager SetClear];
    
    adminGroup = nil;
    joinGroup = nil;
    groupDic = nil;
    groupIdDic = nil;
}

- (void) UpdateLocalData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"profile" ofType:@"plist"];
    
    NSLog(@"save path %@", plistPath);

    NSMutableDictionary* dict = [ [ NSMutableDictionary alloc ] initWithContentsOfFile:plistPath ];
    
    NSData* pwData = [NSData AES256Encode:localPassword];
    
    [ dict setObject:localUserName forKey:@"userName" ];
    [ dict setObject:pwData forKey:@"userKey" ];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"profile.plist"];
    
    [dict writeToFile:plistPath atomically:YES];
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

+ (NSString*) filtStr:(NSString*)inputStr
{
    NSString* result = @"";
    
    result = [result stringByAppendingFormat:@"%@", inputStr];
    
    return result;
}

+ (NSString*) filtStr:(NSString *)inputStr :(NSString *)defaultStr
{
    if ([inputStr isKindOfClass:NSNull.class] || inputStr == nil)
        return defaultStr;
    
    return [self filtStr:inputStr];
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (managerInstance == nil)
        {
            managerInstance = [super allocWithZone:zone];
            managerInstance->initedLocalData = false;
            managerInstance->isdirty = false;
            [managerInstance InitLocalData];
            return managerInstance;
        }
    }
    
    return nil;
}

+ (void)RefreshTagData
{
    NSMutableArray* newTagArray = [[NSMutableArray alloc]init];
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/tag";
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:URL];
    [request setUsername:@"admin"];
    [request setPassword:@"admin"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error)
    {
        NSArray* tags = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];
        
        for (int i = 0; i < tags.count; i++) {
            NSDictionary* item = tags[i];
            TagItem* newTag = [[TagItem alloc]init];
            
            newTag.tagId = item[@"id"];
            newTag.name = item[@"name"];
            
            NSString* clazz = item[@"clazz"];
            if ([clazz isEqualToString:@"Organization"])
                newTag.tagClass = TagOrganization;
            else
                newTag.tagClass = TagActivity;
            
            NSString* defined = item[@"definedBy"];
            if ([defined isEqualToString:@"System"])
                newTag.tagDefined = TagSystem;
            else
                newTag.tagDefined = TagUser;
            
            [newTagArray addObject:newTag];
        }
    }
    
    [UserManager Instance]->tagList = [NSArray arrayWithArray:newTagArray];
}

+ (NSArray*)GetTags
{
    if ([UserManager Instance]->tagList == nil)
        [UserManager RefreshTagData];
    
    return [UserManager Instance]->tagList;
}

+ (void)RefreshGroupData
{
    [[UserManager Instance]RefreshLocalGroupData];
}

- (void) RefreshLocalGroupData
{
    NSNumber* uid = [[UserManager Instance]GetLocalUserId];
    
    if (!adminGroup)
        adminGroup = [[NSMutableArray alloc]init];
    [adminGroup removeAllObjects];
    
    if (!joinGroup)
        joinGroup = [[NSMutableArray alloc]init];
    [joinGroup removeAllObjects];
    
    if (!groupDic)
        groupDic = [[NSMutableDictionary alloc]init];
    [groupDic removeAllObjects];
    
    if (!groupIdDic)
        groupIdDic = [[NSMutableDictionary alloc]init];
    [groupIdDic removeAllObjects];
    
    NSString* URLString = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    URLString = [URLString stringByAppendingFormat:@"%@/associations", uid];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    ASIHTTPRequest *URLRequest = [ASIHTTPRequest requestWithURL:URL];
    [URLRequest setUsername:@"admin"];
    [URLRequest setPassword:@"admin"];
    
    [URLRequest startSynchronous];
    
    NSError *error = [URLRequest error];
    
    if (!error)
    {
        NSArray* returnData = [NSJSONSerialization JSONObjectWithData:[URLRequest responseData] options:NSJSONReadingAllowFragments error:nil][@"content"];
        
        for (int i = 0; i < returnData.count; i++)
        {
            NSDictionary* item = returnData[i];
            NSDictionary* creator = item[@"createdBy"];
            NSNumber* cid = creator[@"id"];
            NSString* groupName = item[@"name"];
            NSNumber* gid = item[@"id"];
            
            if (uid.longValue == cid.longValue)
            {
                [adminGroup addObject:item];
            }
            else
            {
                [joinGroup addObject:item];
            }
            
            NSString* idStr = [NSString stringWithFormat:@"%@",gid];
            
            [groupDic setValue:gid forKey:groupName];
            [groupIdDic setValue:groupName forKey:idStr];
        }
    }
}

- (NSArray*)GetAdminGroup
{
    if (!adminGroup)
        [UserManager RefreshGroupData];
    
    return adminGroup;
}

- (NSArray*)GetJoinGroup
{
    if (!joinGroup)
        [UserManager RefreshGroupData];
    
    return joinGroup;
}

- (NSDictionary*)GetGroupMap
{
    if (!groupDic)
        [UserManager RefreshGroupData];
    
    return groupDic;
}

- (NSDictionary*)GetGroupIdMap
{
    if (!groupIdDic)
        [UserManager RefreshGroupData];
    
    return groupIdDic;
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
