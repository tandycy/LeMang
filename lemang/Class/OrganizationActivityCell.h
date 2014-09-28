//
//  OrganizationActivityCell.h
//  LeMang
//
//  Created by LZ on 9/28/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface OrganizationActivityCell : UITableViewCell
{
    NSDictionary* localData;
}

@property (strong, nonatomic) IBOutlet UILabel *actTitle;
@property (strong, nonatomic) IBOutlet UILabel *actMember;
@property (strong, nonatomic) IBOutlet UIImageView *actState;
- (void) SetData:(NSDictionary*)data;

@end
