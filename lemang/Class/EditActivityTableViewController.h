//
//  CreateActivityTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolManager.h"

@interface EditActivityTableViewController : UITableViewController
{
    NSMutableDictionary* activityData;
}

@property (strong, nonatomic) IBOutlet UITextView *actName;
@property (strong, nonatomic) IBOutlet UITextView *actDescription;

@property (strong, nonatomic) IBOutlet UITextField *startDate;
@property (strong, nonatomic) IBOutlet UITextField *endDate;
@property (strong, nonatomic) IBOutlet UISwitch *allDayTrigger;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;

- (IBAction)selectButton:(id)sender;
- (void)SetActivityData:(NSDictionary*)data;

@end
