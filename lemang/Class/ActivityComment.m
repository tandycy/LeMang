//
//  ActivityComment.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-14.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "ActivityComment.h"

@implementation ActivityComment

@synthesize category;
@synthesize commentName;
@synthesize  commentIcon;
@synthesize  commentTitle;
@synthesize  commentDetail;
@synthesize  commentImg;


+ (id)commentsOfCategory:(NSString*)category commentName:(NSString*)commentName commentIcon:(UIImage*)commentIcon commentTitle:(NSString*)commentTitle commentDetail:(NSString*)commentDetail commentImg:(NSMutableArray*)commentImg
{
    ActivityComment *newComment = [[self alloc] init];
    newComment.category = category;
    newComment.commentName = commentName;
    newComment.commentIcon = commentIcon;
    newComment.commentTitle = commentTitle;
    newComment.commentDetail = commentDetail;
    newComment.commentImg = commentImg;
    return newComment;
}

@end
