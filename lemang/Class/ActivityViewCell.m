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
    
    _actTitle.text = [UserManager filtStr:localData[@"title"] :@""];
    
    NSString* beginTime = [UserManager filtStr:localData[@"beginTime"] : @""];
    NSString* endTime = [UserManager filtStr:localData[@"endTime"] : @""];
    
    NSString* beginDate = [self stringFromDate:[self dateFromString:beginTime]];
    NSString* endDate = [self stringFromDate:[self dateFromString:endTime]];
    
    _actTime.text = [beginDate stringByAppendingFormat:@" ~ %@", endDate];

    _actLimit.text = [UserManager filtStr:localData[@"regionLimit"] : @""];
    
    /*
    NSDictionary* members = localData[@"users"];
    int memberNum = 0;
    if ([members isKindOfClass:[NSDictionary class]])
    {
        memberNum = members.count;
    }
     */
    NSString* memberMax = [UserManager filtStr:localData[@"peopleLimit"] : @""];
    //_actMember.text = [NSString stringWithFormat:@"%d/%@",memberNum,memberMax];
    
    NSDictionary* board = localData[@"board"];
    NSNumber* favNum = [NSNumber numberWithInt:0];
    if ([board isKindOfClass:[NSDictionary class]])
    {
        NSNumber* fav = board[@"bookmarkCount"];
        if ([fav isKindOfClass:[NSDictionary class]])
            favNum = fav;
    }
    _actBookmark.text = [NSString stringWithFormat:@"%@", favNum];
    
    NSString* imgUrlString = [UserManager filtStr:localData[@"iconUrl"] :@""];
    if (imgUrlString.length > 0)
    {
        NSString* tempstr = @"http://e.taoware.com:8080/quickstart/resources/a/";
        tempstr = [tempstr stringByAppendingFormat:@"%@/", localData[@"id"]];
        tempstr = [tempstr stringByAppendingString:imgUrlString];
        imgUrlString = tempstr;
    }
    NSURL* imgUrl = [NSURL URLWithString:imgUrlString];
    [_actIcon LoadFromUrl:imgUrl :[UIImage imageNamed:@"default_Icon"]];
    
    
    NSString* group = localData[@"activityGroup"];
    UIImage* iconImg;
    if ([group isEqualToString:@"Association"])
    {
        iconImg = [UIImage imageNamed:@"group_icon.png"];;
    }
    else if ([group isEqualToString:@"Company"])
    {
        iconImg = [UIImage imageNamed:@"buisness_icon.png"];;
    }
    else if ([group isEqualToString:@"University"])
    {
        iconImg = [UIImage imageNamed:@"school_icon.png"];
    }
    else if ([group isEqualToString:@"Department"])
    {
        iconImg = [UIImage imageNamed:@"private_icon.png"];;
    }
    _actIcon.image = iconImg;
    
    [self UpdateBoard:memberMax];
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
    
    //_actMember.text = [NSString stringWithFormat:@"%@/%@", _act.member, _act.memberUpper];

    _actTypeIcon.image = _act.icon;
    
    [_actIcon LoadFromUrl:_act.imgUrlStr :[UIImage imageNamed:@"default_Icon"]];
    
    [self UpdateBoard:_act.memberUpper];
}

- (void)UpdateBoard:(NSString*)maxMember
{
    NSDictionary* board = localData[@"board"];
    
    NSNumber* bookmarkNum = board[@"bookmarkCount"];
    NSNumber* members = board[@"joinCount"];
    NSNumber* score = board[@"rating"];
    
    _actMember.text = [NSString stringWithFormat:@"%@/%@", members, maxMember];
    _actBookmark.text = [NSString stringWithFormat:@"%@",bookmarkNum];

}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];

    return destDate;
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];

    return destDateString;
}

@end
