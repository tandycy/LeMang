//
//  CreateOrganizationTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-21.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrganizationTableViewController : UITableViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource> 
{
    NSArray *pickerArray;
    NSArray *schoolPickerArray;
    NSArray *collegePickerArray;
}

- (IBAction)selectButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (strong, nonatomic) IBOutlet UIPickerView *selectPicker;
@property (strong, nonatomic) IBOutlet UITextField *schoolTextField;
@property (strong, nonatomic) IBOutlet UITextField *collegeTextField;

@end
