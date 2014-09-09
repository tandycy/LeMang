//
//  UserRegisterViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolManager.h"

@interface UserRegisterViewController : UIViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIActionSheetDelegate>
{
    NSArray *pickerArray;
    NSArray *schoolPickerArray;
    NSArray *collegePickerArray;
    NSArray *areaPickerArray;
    UIImagePickerController *imagePicker;
    UIImage *image;
    
    NSMutableData* receivedData;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgViewBig;
@property (strong, nonatomic) IBOutlet UIButton *pickImgButton;

- (IBAction)OnClickPickImage:(id)sender;
- (IBAction)OnClickPickCamera:(id)sender;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userPW;
@property (strong, nonatomic) IBOutlet UITextField *userPWConform;
@property (strong, nonatomic) IBOutlet UITextField *myUniversity;
@property (strong, nonatomic) IBOutlet UITextField *myArea;
@property (strong, nonatomic) IBOutlet UITextField *myCollege;
@property (strong, nonatomic) IBOutlet UIButton *DoRegister;

@property (strong, nonatomic) IBOutlet UILabel *infoText;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (strong, nonatomic) IBOutlet UIPickerView *selectPicker;

- (IBAction)DoRegister:(id)sender;
- (IBAction)OnSchoolChanged:(UITextField *)sender;

@end
