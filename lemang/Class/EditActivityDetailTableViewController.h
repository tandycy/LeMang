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
#import "ASIFormDataRequest.h"

@interface EditActivityDetailTableViewController : UITableViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIActionSheetDelegate>
{
    NSMutableDictionary* activityData;
    UIImage* iconImage;
    
    UIViewController* rootVC;
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
@property (strong, nonatomic) IBOutlet UISegmentedControl *actType;

//tag button
@property (strong, nonatomic) IBOutlet UIButton *tag1;
@property (strong, nonatomic) IBOutlet UIButton *tag2;
@property (strong, nonatomic) IBOutlet UIButton *tag3;
@property (strong, nonatomic) IBOutlet UIButton *tag4;
@property (strong, nonatomic) IBOutlet UIButton *tag5;
@property (strong, nonatomic) IBOutlet UIButton *tag6;
@property (strong, nonatomic) IBOutlet UIButton *tag7;
@property (strong, nonatomic) IBOutlet UIButton *tag8;
@property (strong, nonatomic) IBOutlet UITextField *otherTag;


@property (strong, nonatomic) IBOutlet UIPickerView *dataPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
- (IBAction)OnTypeChange:(UISegmentedControl *)sender;

- (void) SetActivityData:(NSMutableDictionary*)data;
- (void) SetIconData : (UIImage*)img;
- (void) SetRootView:(UIViewController*)vc;

@end
