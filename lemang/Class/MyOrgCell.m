//
//  MyOrgCell.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyOrgCell.h"

@implementation MyOrgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
