//
//  CreateOrganizationTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-21.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrganizationTableViewController : UITableViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIActionSheetDelegate>
{
    NSArray *pickerArray;
    NSArray *schoolPickerArray;
    NSArray *collegePickerArray;
    UIImagePickerController *imagePicker;
    UIImage *image;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBig;
@property (strong, nonatomic) IBOutlet UIButton *pickImgButton;
- (IBAction)OnClickPickImage:(id)sender;
- (IBAction)OnClickPickCamera:(id)sender;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (IBAction)selectButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (strong, nonatomic) IBOutlet UIPickerView *selectPicker;
@property (strong, nonatomic) IBOutlet UITextField *schoolTextField;
@property (strong, nonatomic) IBOutlet UITextField *collegeTextField;

@end
