//
//  SelectTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-25.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "SchoolManager.h"

@interface SelectTableViewController : UITableViewController
{
    NSMutableArray* hotArray;
    NSArray* schoolArray;
    NSMutableArray* bookmarkArray;
}

@end
