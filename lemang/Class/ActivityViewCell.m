//
//  ActivityViewCell.m
//  LeMang
//
//  Created by LZ on 8/25/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "ActivityViewCell.h"

@implementation ActivityViewCell

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

- (void)SetActData:(NSDictionary *)data
{
    localData = data;
    actId = data[@"id"];
}

- (void) SetActivity:(Activity *)_act
{
    actId = _act.activityId;
    localData = [_act GetActivityData];
    
    _actTitle.text = [UserManager filtStr:_act.title :@""];
    _actTime.text = [UserManager filtStr:_act.date :@""];
    _actLimit.text = [UserManager filtStr:_act.limit :@""];
    
    NSString* favStr = @"";
    favStr = [favStr stringByAppendingFormat:@"%@", _act.fav];
    _actBookmark.text = [UserManager filtStr:favStr :@""];
    
    NSString* memberNum = @"";
    memberNum = [memberNum stringByAppendingFormat:@"%@/%@", _act.member, _act.memberUpper];

    _actTypeIcon.image = _act.icon;
    
    [_actIcon LoadFromUrl:_act.imgUrlStr :[UIImage imageNamed:@"default_Icon"]];
}


@end
