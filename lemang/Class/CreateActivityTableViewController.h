//
//  CreateActivityTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-20.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "SchoolManager.h"

@interface CreateActivityTableViewController : UITableViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableDictionary* activityData;
    NSString* startDataText;
    NSString* endDataText;
    id owner;
}

@property (strong, nonatomic) IBOutlet UITextView *actName;
@property (strong, nonatomic) IBOutlet UITextView *actDescription;

@property (strong, nonatomic) IBOutlet UITextField *startDate;
@property (strong, nonatomic) IBOutlet UITextField *endDate;
@property (strong, nonatomic) IBOutlet UISwitch *allDayTrigger;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *actHostType;
@property (strong, nonatomic) IBOutlet UITextField *actHost;
@property (strong, nonatomic) IBOutlet UITextField *actUniversity;
@property (strong, nonatomic) IBOutlet UITextField *actArea;
@property (strong, nonatomic) IBOutlet UITextField *actCollege;
@property (strong, nonatomic) IBOutlet UITextField *actLocation;
@property (strong, nonatomic) IBOutlet UITextField *actPeopleLimit;
@property (strong, nonatomic) IBOutlet UITextField *otherTag;
@property (strong, nonatomic) IBOutlet UIPickerView *dataPicker;

//tag buttons
//tag button
@property (strong, nonatomic) IBOutlet UIButton *tag1;
@property (strong, nonatomic) IBOutlet UIButton *tag2;
@property (strong, nonatomic) IBOutlet UIButton *tag3;
@property (strong, nonatomic) IBOutlet UIButton *tag4;
@property (strong, nonatomic) IBOutlet UIButton *tag5;
@property (strong, nonatomic) IBOutlet UIButton *tag6;
@property (strong, nonatomic) IBOutlet UIButton *tag7;
@property (strong, nonatomic) IBOutlet UIButton *tag8;

- (IBAction)selectButton:(id)sender;
- (void)SetOwner:(id)_owner;

@end
