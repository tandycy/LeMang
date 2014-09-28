//
//  UserVerifyViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageViewLoaderWithButton.h"

@interface UserVerifyViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet IconImageViewLoaderWithButton *userVerifyPhoto;
@property (strong, nonatomic) IBOutlet UITextField *userRealName;
@property (strong, nonatomic) IBOutlet UITextField *userCode;

@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end
