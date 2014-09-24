//
//  OrganizationTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "OrganizationViewCell.h"
#import "OrganizationDetailTableViewController.h"
#import "CreateOrganizationTableViewController.h"

@interface OrganizationTableViewController : UITableViewController
{
    NSMutableArray* organizationData;
}
@property (strong, nonatomic) IBOutlet UITableView *localTabelView;
- (IBAction)OnCreateOrganization:(id)sender;
- (void)OnCreateDone;

@end
