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
    
    bool isActivity;
    NSString* groupName;
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

- (IBAction)OnTypeChange:(UISegmentedControl *)sender;
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

@property (strong, nonatomic) IBOutlet UILabel *titleTop;
@property (strong, nonatomic) IBOutlet UILabel *titleDesc;
@property (strong, nonatomic) IBOutlet UILabel *titleTimeBegin;
@property (strong, nonatomic) IBOutlet UILabel *titleTimeEnd;
@property (strong, nonatomic) IBOutlet UILabel *titleSchool;
@property (strong, nonatomic) IBOutlet UILabel *titleArea;
@property (strong, nonatomic) IBOutlet UILabel *titleDepart;
@property (strong, nonatomic) IBOutlet UILabel *titleAddress;
@property (strong, nonatomic) IBOutlet UILabel *titleTag;

@property (strong, nonatomic) IBOutlet UITableViewCell *groupCell;

- (IBAction)selectButton:(id)sender;
- (void)SetActivity:(id)_owner;
- (void)SetAnnounce:(NSString*)gname;

@end
