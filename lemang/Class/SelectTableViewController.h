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
#import "FPPopoverController.h"

@interface SelectTableViewController : UITableViewController
{
    NSMutableArray* hotArray;
    NSArray* schoolArray;
    NSMutableArray* bookmarkArray;
    
    bool isactivity;
    UIViewController* owner;
    FPPopoverController* popoverControl;
}

-(void)SetAsActivity:(UIViewController*)_owner :(FPPopoverController*)popover;
-(void)SetAsOrganization:(UIViewController*)_owner :(FPPopoverController*)popover;

@end
