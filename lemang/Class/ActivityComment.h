//
//  ActivityComment.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-14.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityComment : NSObject{
    NSString *category;
    NSString *commentName;
    UIImage *commentIcon;
    NSString *commentTitle;
    NSString *commentDetail;
    NSMutableArray *commentImg;
}

@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *commentName;
@property (nonatomic,copy) UIImage *commentIcon;
@property (nonatomic,copy) NSString *commentTitle;
@property (nonatomic,copy) NSString *commentDetail;
@property (nonatomic,copy) NSMutableArray *commentImg;


+ (id)commentsOfCategory:(NSString*)category commentName:(NSString*)commentName commentIcon:(UIImage*)commentIcon commentTitle:(NSString*)commentTitle commentDetail:(NSString*)commentDetail commentImg:(NSMutableArray*)commentImg;
@end
