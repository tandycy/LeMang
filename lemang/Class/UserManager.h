//
//  UserManager.h
//  LeMang
//
//  Created by LZ on 9/2/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringEncoder.h"

@protocol UserLoginDelegate <NSObject>

-(void) UserLoginContact;

@end


@interface UserManager : NSObject
{
    NSString* localUserName;
    NSString* localPassword;
    int localUserId;
    bool initedLocalData;
    
    NSMutableData* receivedData;
    
    id <UserLoginDelegate> loginDelegate;
}

@property (nonatomic, strong) id<UserLoginDelegate>loginDelegate;
+ (UserManager*) Instance;
+ (NSString*) UserName;
+ (NSString*) UserPW;

+ (bool) IsInitSuccess;
- (int) GetLocalUserId;
- (void) DoLogIn : (NSString*)name :(NSString*)pw;
- (void) ClearLocalUserData;
//- (void) InitLocalData;
- (void) LogInCheck;
- (void) UpdateLocalData;

@end