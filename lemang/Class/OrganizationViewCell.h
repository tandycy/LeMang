//
//  OrganizationViewCell.h
//  LeMang
//
//  Created by LZ on 8/29/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *organizationNameTxt;
@property (strong, nonatomic) IBOutlet UIImageView *organizationIcon;
@property (strong, nonatomic) IBOutlet UIImageView *typeIcon;
@property (strong, nonatomic) IBOutlet UILabel *memberNumberTxt;
@property (strong, nonatomic) IBOutlet UILabel *memberLimitTxt;
@property (strong, nonatomic) IBOutlet UILabel *areaLimitTxt;

@end