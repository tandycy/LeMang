//
//  UserVerifyViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IconImageButtonLoader.h"
#import "ASIFormDataRequest.h"

@interface UserVerifyViewController : UIViewController<UITextFieldDelegate>
{    
    UIImagePickerController *imagePicker;
    UIImage* photoImg;
}

@property (strong, nonatomic) IBOutlet IconImageButtonLoader *userVerifyPhoto;
@property (strong, nonatomic) IBOutlet UITextField *userRealName;
@property (strong, nonatomic) IBOutlet UITextField *userCode;
- (IBAction)OnClickPhoto:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end
