//
//  Activity.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-1.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject{
    long activityId;
    NSURL *img;
    UIImage* cachedImg;
    NSString *title;
    NSString *date;
    NSString *limit;
    UIImage *icon;
    NSString *member;
    NSString *memberUpper;
    NSString *fav;
    BOOL *state;
}
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSURL *img;
@property (nonatomic, copy) UIImage* cachedImg;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) UIImage *icon;
@property (nonatomic, copy) NSString *member;
@property (nonatomic, copy) NSString *memberUpper;
@property (nonatomic, copy) NSString *fav;
@property (nonatomic) BOOL *state;
@property (nonatomic) long activityId;

+ (id)activityOfCategory:(NSString*)category img:(NSURL*)img title:(NSString*)title date:(NSString*)date
                   limit:(NSString*)limit icon:(UIImage*)icon member:(NSString*)member memberUpper:(NSString*)memberUpper fav:(NSString*)fav state:(BOOL*)state activitiId:(long)activitiId;

@end
