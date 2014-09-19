//
//  Activity.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-1.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject{
    NSNumber* activityId;
    NSNumber* creatorId;
    NSURL *imgUrlStr;
    UIImage* cachedImg;
    NSString *title;
    NSString *date;
    NSString *limit;
    UIImage *icon;
    NSString *member;
    NSString *memberUpper;
    NSNumber *fav;
    BOOL *state;
    NSArray* memberList;
    NSDictionary* activityData;
}
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSURL *imgUrlStr;
@property (nonatomic, copy) UIImage* cachedImg;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) UIImage *icon;
@property (nonatomic, copy) NSString *member;
@property (nonatomic, copy) NSString *memberUpper;
@property (nonatomic, copy) NSNumber *fav;
@property (nonatomic) BOOL *state;
@property (nonatomic, copy) NSNumber* activityId;
@property (nonatomic, copy) NSNumber* creatorId;

+ (id)activityOfCategory:(NSString*)category imgUrlStr:(NSURL*)imgUrlStr title:(NSString*)title date:(NSString*)date
                   limit:(NSString*)limit icon:(UIImage*)icon member:(NSString*)member memberUpper:(NSString*)memberUpper fav:(NSNumber*)fav state:(BOOL*)state activitiId:(NSNumber*)activitiId creatorId:(NSNumber*)creatorId;

- (void) SetActivityData : (NSDictionary*)dataItem;
- (void) SetActivityMember: (NSArray*)memberDataList;
- (NSArray*)GetMemberList;
- (NSDictionary*)GetActivityData;

@end
