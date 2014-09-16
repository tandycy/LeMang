//
//  CreateActivityDetailTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-11.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolManager.h"
#import "UserManager.h"

@interface CreateActivityDetailTableViewController : UITableViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIActionSheetDelegate>
{
}

@property (strong,nonatomic) NSString *actTitle;
@property (strong,nonatomic) NSString *actDescription;
@property (strong,nonatomic) NSString *actStartDate;
@property (strong,nonatomic) NSString *actEndDate;
@property BOOL isAllDay;
@property (strong,nonatomic) UIImage *actIcon;

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

@property (strong, nonatomic) IBOutlet UIPickerView *dataPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;

@end