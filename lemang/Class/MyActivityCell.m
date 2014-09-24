//
//  MyActivityCell.m
//  lemang
//
//  Created by LiZheng on 9/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "MyActivityCell.h"

@implementation MyActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)ClearData
{
    localData = nil;
    
    _actMember.text = @"";
    _actTitle.text = @"";
}

- (void)SetData:(NSDictionary *)data
{
    [self ClearData];
    
    if (data == nil || data == NULL)
        return;
    
    localData = data;
    
    _actTitle.text = localData[@"title"];
    
    NSDictionary* members = localData[@"users"];
    int memberNum = 0;
    if ([members isKindOfClass:[NSDictionary class]])
    {
        memberNum = members.count;
    }
    _actMember.text = [NSString stringWithFormat:@"%d", memberNum];
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

- (IBAction)DoActEdit:(id)sender {
}
@end
