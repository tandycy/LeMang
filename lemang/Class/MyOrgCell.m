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

-(IBAction)DoOrgEdit:(id)sender
{
        if (![owner isKindOfClass:[MyOrganizationTableViewController class]])
            return;
        
        MyOrganizationTableViewController* parView = (MyOrganizationTableViewController*)owner;
    
        EditOrganizationTableViewController *EditOrgVC = [parView.storyboard instantiateViewControllerWithIdentifier:@"EditOrganizationTableViewController"];
        EditOrgVC.navigationItem.title = @"编辑组织";
        //NSNumber* aid = localData[@"id"];
        //[EditOrgVC SetActivityDataFromId:aid];
        [parView.navigationController pushViewController:EditOrgVC animated:YES];
}

@end
