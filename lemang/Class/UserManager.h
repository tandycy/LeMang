//
//  UserManager.h
//  LeMang
//
//  Created by LZ on 9/2/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringEncoder.h"

@interface UserManager : NSObject
{
    NSString* localUserName;
    NSString* localPassword;
    bool initedLocalData;
}

+ (UserManager*) Instance;

- (bool) InitLocalData;
- (void) UpdateLocalData;

@end
