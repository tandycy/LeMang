//
//  OrganizationViewCell.h
//  LeMang
//
//  Created by LZ on 8/29/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IconImageViewLoader.h"

@interface OrganizationViewCell : UITableViewCell
{
    enum OrgType
    {
        University,
        Department,
        Company,
        Association,
        Person,
    }orgType;
    
    NSDictionary* localData;
    NSNumber* organizationId;
    
    int memberNum;
    NSNumber* maxMemberNum;

}

@property (strong, nonatomic) IBOutlet UILabel *organizationNameTxt;
@property (strong, nonatomic) IBOutlet IconImageViewLoader *organizationIcon;
@property (strong, nonatomic) IBOutlet UIImageView *typeIcon;
@property (strong, nonatomic) IBOutlet UILabel *favNumberTxt;    // member/fav number
@property (strong, nonatomic) IBOutlet UILabel *memberLimitTxt; // age limit?
@property (strong, nonatomic) IBOutlet UILabel *areaLimitTxt;

@property (strong, nonatomic) IBOutlet UIImageView *favIcon;

- (void) updateData:(NSDictionary*)newData;
- (void) updateDisplay;
- (NSDictionary*) getLocalData;

@end
