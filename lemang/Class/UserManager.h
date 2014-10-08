//
//  UserManager.h
//  LeMang
//
//  Created by LZ on 9/2/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringEncoder.h"
#import "TagItem.h"
#import "ASIHTTPRequest.h"

@protocol UserLoginDelegate <NSObject>

-(void) UserLoginContact;

@end


@interface UserManager : NSObject
{
    NSString* localUserName;
    NSString* localPassword;
    NSString* localNickName;
    int localUserId;
    bool initedLocalData;
    bool isCertify;
    
    NSMutableData* receivedData;
    
    NSDictionary* localUserData;
    
    id <UserLoginDelegate> loginDelegate;
    
    UIImage* defaultIcon;
    
    bool isdirty;
    
    NSArray* tagList;
    
    NSMutableArray* adminGroup;
    NSMutableArray* joinGroup;
    
    NSMutableDictionary* groupDic;
    NSMutableDictionary* groupIdDic;
}

@property (nonatomic, strong) id<UserLoginDelegate>loginDelegate;
+ (UserManager*) Instance;
+ (NSString*) UserNick;
+ (NSString*) UserName;
+ (NSString*) UserPW;
+ (NSDictionary*) LocalUserData;
+ (UIImage*) DefaultIcon;
+ (NSString*) filtStr:(NSString*)inputStr;
+ (NSString*) filtStr:(NSString*)inputStr :(NSString*)defaultStr;
+ (void) RefreshUserData;
+ (void) RefreshTagData;
+ (NSArray*) GetTags;
+ (void) RefreshGroupData;


+ (bool)IsUserNameExists:(NSString*)nameData;
+ (bool) IsInitSuccess;
+ (bool) IsUserAuthen;

- (void) RefreshData;
- (int) GetLocalUserId;
- (NSArray*)GetJoinGroup;
- (NSArray*)GetAdminGroup;
- (NSDictionary*)GetGroupMap;
- (NSDictionary*)GetGroupIdMap;
- (void) DoLogIn : (NSString*)name :(NSString*)pw;
- (void) ClearLocalUserData;
//- (void) InitLocalData;
- (void) LogInCheck;
- (void) UpdateLocalData;
- (void) SetAuthen;

+ (void) SetDirty;
+ (void) SetClear;
+ (bool) IsDirty;

+ (bool) IsTestVersion;

@end
