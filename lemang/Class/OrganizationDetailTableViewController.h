//
//  OrganizationDetailTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-19.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationViewCell.h"
#import "OrganizationActivityCell.h"

@interface OrganizationDetailTableViewController : UITableViewController
{
    enum OrgnizationType orgType;
    NSNumber* orgId;
    NSDictionary* localData;
    UIImage* localIconData;
    
    NSArray* activityArray;
}

@property IBOutlet UIView *orgDetailTitleView;

@property (strong, nonatomic) IBOutlet UILabel *orgnizationTittle;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *organizationIcon;
@property (strong, nonatomic) IBOutlet UILabel *organizationDetail;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (void) updateDisplay;
- (void) SetOrgnizationId:(NSNumber*)oid;
- (void) SetOrgnizationData:(NSDictionary*)data;
- (void) SetOrgnizationIcon:(UIImage*)image;


@end
