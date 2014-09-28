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
#import "FPPopoverController.h"

@interface OrganizationTableViewController : UITableViewController
{
    NSMutableArray* organizationArray;
    
    int currentPage;
    int nextPage;
    int pageSize;
    int maxPage;
}
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *localTabelView;
- (IBAction)OnCreateOrganization:(id)sender;
- (void)OnCreateDone;

@end
