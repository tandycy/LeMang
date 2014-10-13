//
//  OrganizationViewCell.m
//  LeMang
//
//  Created by LZ on 8/29/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "Constants.h"
#import "OrganizationViewCell.h"

@implementation OrganizationViewCell
{
    UILabel* memberNumberText;
    NSMutableArray* tagItemArray;
}

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

- (NSNumber*) getOrgId
{
    return organizationId;
}

- (void)ParseOrgType:(NSString*)input
{
    if ([input isEqualToString:@"University"])
    {
        orgType = University;
        [_typeIcon setImage:[UIImage imageNamed:@"school_icon"]];
    }
    else if ([input isEqualToString:@"Department"])
    {
        orgType = Department;
        [_typeIcon setImage:[UIImage imageNamed:@"coll_icon"]];
    }
    else if ([input isEqualToString:@"Person"])
    {
        orgType = Person;
        [_typeIcon setImage:[UIImage imageNamed:@"private_icon"]];
    }
    else if ([input isEqualToString:@"Association"])
    {
        orgType = Association;
        [_typeIcon setImage:[UIImage imageNamed:@"group_icon"]];
    }
    else if ([input isEqualToString:@"Company"])
    {
        orgType = Company;
        [_typeIcon setImage:[UIImage imageNamed:@"buisness_icon"]];
    }
}

- (void) updateDisplay
{
    if (localData == Nil)
        return;
    
   
    // - id - contact - department - peopleLimit - tags - type - description - iconUrl - address - regionLimit - otherLimit - linkUrl - name - area - shortName - createdBy - createdDate - university
    
    NSString* orgName = [UserManager filtStr:localData[@"name"]];
    organizationId = localData[@"id"];
    _organizationNameTxt.text = orgName;
    maxMemberNum = localData[@"peopleLimit"];
    _areaLimitTxt.text = [UserManager filtStr:localData[@"regionLimit"]: @"无地区限制"];
    

    NSString* orgnizaitonType = localData[@"type"];

    [self ParseOrgType:orgnizaitonType];
    
    NSArray* memberArray = localData[@"associationMember"];
    memberNum = memberArray.count;
    
    _favNumberTxt.text = @"0";
    _memberLimitTxt.text = @"";

    if (orgType == Association || orgType == Person)
        [self UpdateMemberNumber];
    
    // Download icon
    
    NSString* urlStr = [UserManager filtStr:localData[@"iconUrl"]];
    
    if (urlStr.length > 0)
    {
        NSString* tempstr = @"http://e.taoware.com:8080/quickstart/resources";
        //tempstr = [tempstr stringByAppendingFormat:@"/g/@/", organizationId];
        tempstr = [tempstr stringByAppendingString:urlStr];
        urlStr = tempstr;
    }
    
    [_organizationIcon LoadFromUrl:[NSURL URLWithString:urlStr]:[UIImage imageNamed:@"default_Icon.png"]];
    
    [self UpdateTags];
}

- (void) UpdateTags
{
    if (tagItemArray)
    {
        for (UIImageView* item in tagItemArray)
        {
            [item removeFromSuperview];
        }
    }
    else
        tagItemArray = [[NSMutableArray alloc]init];
    
    NSMutableArray* filteredTags = [[NSMutableArray alloc]init];
    NSString* tags = [UserManager filtStr:localData[@"tags"]:@""];
    
    NSArray *tagArray1 = [tags componentsSeparatedByString:@";"];
    
    for (NSString* tagPart1 in tagArray1)
    {
        NSArray *tagArray2 = [tagPart1 componentsSeparatedByString:@"；"];
        
        if (tagArray2.count > 1)
            NSLog(@"Meet CN ; symble.");
        
        for (NSString* tagPart2 in tagArray2)
        {
            if (tagPart2.length > 0)
                [filteredTags addObject:tagPart2];
        }
    }
    
    int maxNumber = 4;
    if (filteredTags.count < maxNumber)
        maxNumber = filteredTags.count;
    
    CGRect tagTitleFrame2 = CGRectMake(0, 0, 32, 18);
    CGRect tagTitleFrame3 = CGRectMake(0, 0, 43, 18);
    CGRect tagTitleFrame4 = CGRectMake(0, 0, 54, 18);
    
    int index = 92;
    for (int i = 0; i < maxNumber; i++)
    {
        NSString* item = filteredTags[i];
        UIImageView* tagItem;
        UILabel* tagTitle;
        
        if (item.length <= 2)
        {
            CGRect backFrame = CGRectMake(index, 60, 32, 18);
            tagItem = [[UIImageView alloc]initWithFrame:backFrame];
            tagItem.image = [UIImage imageNamed:@"tags_2"];
            tagTitle = [[UILabel alloc]initWithFrame:tagTitleFrame2];
            index += (32 + 7);
        }
        else if (item.length == 3)
        {
            CGRect backFrame = CGRectMake(index, 60, 43, 18);
            tagItem = [[UIImageView alloc]initWithFrame:backFrame];
            tagItem.image = [UIImage imageNamed:@"tags_3"];
            tagTitle = [[UILabel alloc]initWithFrame:tagTitleFrame3];
            index += (43 + 7);
        }
        else
        {
            CGRect backFrame = CGRectMake(index, 60, 54, 18);
            tagItem = [[UIImageView alloc]initWithFrame:backFrame];
            tagItem.image = [UIImage imageNamed:@"tags_4"];
            tagTitle = [[UILabel alloc]initWithFrame:tagTitleFrame4];
            index += (54 + 7);
        }
        
        
        tagTitle.text = item;
        tagTitle.textAlignment = UITextAlignmentCenter;
        tagTitle.font = [UIFont fontWithName:defaultFont size:12];
        tagTitle.textColor = defaultMainColor;
        
        [tagItem addSubview:tagTitle];
        [self addSubview:tagItem];
        [tagItemArray addObject:tagItem];
    }
}

- (void) UpdateMemberNumber
{
    if (memberNumberText == nil)
    {
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"org_back.png"]];
        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"org_back_down.png"]];
        
        
        UILabel *memberNumberBack = [[UILabel alloc]initWithFrame:CGRectMake(11, 62, 70, 15)];
        UIImageView *memberNumberBackImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like_number_back.png"]];
        [memberNumberBack addSubview:memberNumberBackImg];
        [self addSubview:memberNumberBack];
        
        memberNumberText = [[UILabel alloc]initWithFrame:CGRectMake(36, 63, 45, 14)];
        memberNumberText.text = @"100";
        memberNumberText.font = [UIFont fontWithName:defaultFont size:13];
        memberNumberText.textColor = [UIColor whiteColor];
        [self addSubview:memberNumberText];
        
        UILabel *memberIcon = [[UILabel alloc]initWithFrame:CGRectMake(18, 63, 10, 10)];
        UIImageView *memberIconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_number.png"]];
        [memberIcon addSubview:memberIconImg];
        [self addSubview:memberIcon];
    }
    
    memberNumberText.text = [NSString stringWithFormat:@"%d",memberNum];
}

@end
