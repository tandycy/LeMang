//
//  OrganizationActivityCell.m
//  LeMang
//
//  Created by LZ on 9/28/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "OrganizationActivityCell.h"

@implementation OrganizationActivityCell

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

- (void)SetData:(NSDictionary *)data
{
    localData = data;
}

@end
