//
//  ActivityCommentTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-14.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityCommentCell.h"

@interface ActivityCommentTableViewController : UITableViewController
{
    NSArray* localComments;
    NSMutableArray* cellArray;
}

- (void) SetCommentList:(NSArray*)commentList;

@end
