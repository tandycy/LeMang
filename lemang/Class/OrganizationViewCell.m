//
//  OrganizationViewCell.m
//  LeMang
//
//  Created by LZ on 8/29/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "OrganizationViewCell.h"

@implementation OrganizationViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateData:(NSDictionary *)newData
{
    localData = newData;
    organizationId = newData[@"id"];
    
    [self updateDisplay];
}

- (NSDictionary*) getLocalData
{
    return localData;
}

- (UIImage*) getLocalIconImage
{
    return localIconImg;
}

- (void) updateDisplay
{
    if (localData == Nil)
        return;
    
    NSString* orgName = [UserManager filtStr:localData[@"name"]];
    _organizationNameTxt.text = orgName;
    _memberLimitTxt.text = [UserManager filtStr:localData[@"peopleLimit"]];
    _areaLimitTxt.text = [UserManager filtStr:localData[@"regionLimit"]];
    
    NSArray* memberArray = localData[@"associationMember"];
    _memberNumberTxt.text = [NSString stringWithFormat:@"%d", memberArray.count];
    
    // Download icon
    
    NSString* urlStr = [UserManager filtStr:localData[@"iconUrl"]];
    
    [_organizationIcon LoadFromUrl:[NSURL URLWithString:urlStr]:[UIImage imageNamed:@"default_Icon.png"]];
}

@end
