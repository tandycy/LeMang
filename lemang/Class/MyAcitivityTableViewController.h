//
//  MyAcitivityTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "MyActivityCell.h"

@interface MyAcitivityTableViewController : UITableViewController
{
    NSMutableArray* adminActivity;
    NSMutableArray* joinedActivity;
    NSMutableArray* bookmarkActivity;
}

@end
