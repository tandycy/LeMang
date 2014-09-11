//
//  CreateActivityDetailTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateActivityDetailTableViewController : UITableViewController
{
    NSString *actTitle;
    NSString *actDescription;
    NSString *actStartDate;
    NSString *actEndDate;
    UIImage *actIcon;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *actHostType;
@property (strong, nonatomic) IBOutlet UITextField *actHost;
@property (strong, nonatomic) IBOutlet UITextField *actUniversity;
@property (strong, nonatomic) IBOutlet UITextField *actArea;
@property (strong, nonatomic) IBOutlet UITextField *actCollege;
@property (strong, nonatomic) IBOutlet UITextField *actLocation;
@property (strong, nonatomic) IBOutlet UITextField *actContact;
@property (strong, nonatomic) IBOutlet UITextField *actPeopleLimit;
@property (strong, nonatomic) IBOutlet UISegmentedControl *actAreaLimit;
@property (strong, nonatomic) IBOutlet UITextField *actOtherLimit;
@property (strong, nonatomic) IBOutlet UISegmentedControl *actTags;
@property (strong, nonatomic) IBOutlet UITextField *otherTag;

@end
