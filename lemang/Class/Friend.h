//
//  Friend.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserManager.h"

@interface Friend : NSObject{
    NSDictionary* localData;
}

@property (nonatomic, copy) NSString* category;
@property (nonatomic, copy) NSNumber* userId;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* userSchool;
@property (nonatomic, copy) NSString* userCollege;
@property (nonatomic, copy) NSString* userIconUrl;

- (void) SetData : (NSDictionary*)data;

@end
