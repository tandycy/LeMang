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
#import "CreateActivityTableViewController.h"

@interface OrganizationDetailTableViewController : UITableViewController
{
    enum OrgnizationType orgType;
    NSNumber* orgId;
    NSString* orgName;
    NSNumber* creatorId;
    NSDictionary* localData;
    UIImage* localIconData;
    
    NSArray* activityArray;
}

@property IBOutlet UIView *orgDetailTitleView;

@property (strong, nonatomic) IBOutlet UIView *upperView;
@property (strong, nonatomic) IBOutlet UILabel *orgnizationTittle;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *organizationIcon;
@property (strong, nonatomic) IBOutlet UILabel *organizationDetail;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (void) updateDisplay;
- (void) SetOrgnizationId:(NSNumber*)oid;
- (void) SetOrgnizationData:(NSDictionary*)data;
- (void) SetOrgnizationIcon:(UIImage*)image;


@end
