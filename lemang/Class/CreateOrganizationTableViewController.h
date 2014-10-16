//
//  CreateOrganizationTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-21.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "SchoolManager.h"

@interface CreateOrganizationTableViewController : UITableViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIActionSheetDelegate>
{
    NSArray *pickerArray;
    NSArray *schoolPickerArray;
    NSArray *collegePickerArray;
    NSArray *areaPickerArray;
    UIImagePickerController *imagePicker;
    UIImage *image;
    
    id owner;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBig;
@property (strong, nonatomic) IBOutlet UIButton *pickImgButton;
@property (strong, nonatomic) IBOutlet UITextField *orgName;
@property (strong, nonatomic) IBOutlet UITextView *orgDescription;

- (IBAction)OnClickPickImage:(id)sender;
- (IBAction)OnClickPickCamera:(id)sender;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (IBAction)selectButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (strong, nonatomic) IBOutlet UIPickerView *selectPicker;
@property (strong, nonatomic) IBOutlet UITextField *schoolTextField;
@property (strong, nonatomic) IBOutlet UITextField *collegeTextField;
@property (strong, nonatomic) IBOutlet UITextField *areaTextField;

@property (strong, nonatomic) IBOutlet UIButton *tag1;
@property (strong, nonatomic) IBOutlet UIButton *tag2;
@property (strong, nonatomic) IBOutlet UIButton *tag3;
@property (strong, nonatomic) IBOutlet UIButton *tag4;
@property (strong, nonatomic) IBOutlet UIButton *tag5;
@property (strong, nonatomic) IBOutlet UIButton *tag6;
@property (strong, nonatomic) IBOutlet UIButton *tag7;
@property (strong, nonatomic) IBOutlet UIButton *tag8;
@property (strong, nonatomic) IBOutlet UITextField *otherTag;

- (void)SetOwner:(id)_owner;

@end
