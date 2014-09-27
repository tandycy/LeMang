//
//  MyOrgCell.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MyOrgCell.h"
#import "MyOrganizationTableViewController.h"
#import "EditOrganizationTableViewController.h"

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

- (void)ClearData
{
    localData = nil;
    
    _orgMember.text = @"";
    _orgTitle.text = @"";
    
}

- (void)SetData:(NSDictionary *)data : (id)_owner;
{
    [self ClearData];
    
    if (data == nil || data == NULL)
    {
        [_buttonEdit setHidden:true];
        [_buttonInvite setHidden:true];
        return;
    }
    
    owner = _owner;
    localData = data;
    
    _orgTitle.text = localData[@"name"];
    
    NSDictionary* members = localData[@"users"];
    int memberNum = 0;
    if ([members isKindOfClass:[NSDictionary class]])
    {
        memberNum = members.count;
    }
    _orgMember.text = [NSString stringWithFormat:@"%d", memberNum];
}

- (void)SetAdmin
{
    [_buttonEdit setHidden:FALSE];
    [_buttonInvite setHidden:FALSE];
}

- (void)SetJoin
{
    [_buttonEdit setHidden:true];
    [_buttonInvite setHidden:FALSE];
}

- (void)SetBookmark
{
    [_buttonEdit setHidden:true];
    [_buttonInvite setHidden:true];
}

-(IBAction)DoOrgEdit:(id)sender
{
    if (![owner isKindOfClass:[MyOrganizationTableViewController class]])
        return;
    
    MyOrganizationTableViewController* parView = (MyOrganizationTableViewController*)owner;
    
    EditOrganizationTableViewController *EditOrgVC = [parView.storyboard instantiateViewControllerWithIdentifier:@"EditOrganizationTableViewController"];
    EditOrgVC.navigationItem.title = @"编辑组织";
    NSNumber* orgId = localData[@"id"];
    [EditOrgVC SetOrganizationDataFromId:orgId];
    [parView.navigationController pushViewController:EditOrgVC animated:YES];
}

- (IBAction)DoActInvite:(id)sender{
}

@end
