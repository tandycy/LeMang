//
//  OrganizationTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationViewCell.h"

@interface OrganizationTableViewController : UITableViewController
{    
    NSMutableData* receivedData;
    NSArray* organizationData;
}
@property (strong, nonatomic) IBOutlet UITableView *localTabelView;

@end
