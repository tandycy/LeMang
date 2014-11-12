//
//  ChangePassViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14/11/12.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassViewController : UIViewController
{
}

@property (strong,nonatomic) UITextView *editText;
@property (strong, nonatomic) IBOutlet UITextField *oldPass;
@property (strong, nonatomic) IBOutlet UITextField *replacePass;
@property (strong, nonatomic) IBOutlet UITextField *replacePassAgain;

@end
