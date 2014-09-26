//
//  CreateActivityTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-26.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolManager.h"
#import "IconImageButtonLoader.h"

@interface EditActivityTableViewController : UITableViewController
{
    NSMutableDictionary* activityData;
    UIImage* localNewIcon;
    UIImage* originIcon;
}

@property (strong, nonatomic) IBOutlet UITextView *actName;
@property (strong, nonatomic) IBOutlet UITextView *actDescription;

@property (strong, nonatomic) IBOutlet UITextField *startDate;
@property (strong, nonatomic) IBOutlet UITextField *endDate;
@property (strong, nonatomic) IBOutlet UISwitch *allDayTrigger;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;

@property (strong, nonatomic) IBOutlet UIButton *CancelPhotoButton;
@property (strong, nonatomic) IBOutlet IconImageButtonLoader *AddPhotoButton;

- (IBAction)selectButton:(id)sender;
- (IBAction)OnChangePhoto:(id)sender;
- (IBAction)OnCancelPhoto:(id)sender;
- (void)SetActivityData:(NSDictionary*)data;
- (void)SetActivityDataFromId:(NSNumber*)actId;

@end
