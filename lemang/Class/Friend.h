//
//  Friend.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject{
    
    NSString* category;
    NSNumber* userId;
    NSString *userName;
    NSString *userSchool;
    NSString *userCollege;
}
@property (nonatomic, copy) NSString* category;
@property (nonatomic, copy) NSNumber* userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSchool;
@property (nonatomic, copy) NSString *userCollege;

+ (id)friendOfCategory:(NSString*)category userId:(NSNumber*)userId userName:(NSString*)userName userSchool:(NSString*)userSchool userCollege:(NSString*)userCollege;

@end
