//
//  OrganizationDetailTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationViewCell.h"

@interface OrganizationDetailTableViewController : UITableViewController

@property IBOutlet UIView *orgDetailTitleView;
@property (strong,nonatomic) OrganizationViewCell *linkedCell;
@property (strong,nonatomic) NSArray *activityArray;

@property (strong, nonatomic) IBOutlet UILabel *orgnizationTittle;
@property (strong, nonatomic) IBOutlet UIImageView *organizationIcon;
@property (strong, nonatomic) IBOutlet UILabel *organizationDetail;
- (void) updateDisplay;

@end
