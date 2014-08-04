//
//  Activity.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-1.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject{
    NSString *name;
    UIImage *icon;
}
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UIImage *icon;

+ (id)activityOfCategory:(NSString*)category name:(NSString*)name icon:(UIImage*)icon;

@end
