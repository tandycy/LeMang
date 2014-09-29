//
//  MobilePhoneVerifyViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-28.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface MobilePhoneVerifyViewController : UIViewController
{
    NSNumber* verifyNum;
}

@property (strong,nonatomic) UITextField *mobliePhoneNumber;

@end
