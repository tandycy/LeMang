//
//  EditOrganizationDetailTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-27.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "ASIFormDataRequest.h"

@interface EditOrganizationDetailTableViewController : UITableViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIActionSheetDelegate>
{
    NSMutableDictionary* orgData;
    UIImage* iconImage;
    
    UIViewController* rootVC;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *orgType;
@property (strong, nonatomic) IBOutlet UITextField *orgSchool;
@property (strong, nonatomic) IBOutlet UITextField *orgArea;
@property (strong, nonatomic) IBOutlet UITextField *orgCollege;
@property (strong, nonatomic) IBOutlet UITextField *orgAddress;
@property (strong, nonatomic) IBOutlet UITextField *orgContact;
@property (strong, nonatomic) IBOutlet UITextField *otherLimit;

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

- (void) SetOrganizationData:(NSMutableDictionary*)data;
- (void) SetIconData : (UIImage*)img;
- (void)SetRootView:(UIViewController*)vc;


@end
