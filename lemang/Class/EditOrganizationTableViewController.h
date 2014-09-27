//
//  EditOrganizationTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-27.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconImageButtonLoader.h"

@interface EditOrganizationTableViewController : UITableViewController
{
    UIImagePickerController *imagePicker;
}

@property (strong, nonatomic) IBOutlet UITextView *orgName;
@property (strong, nonatomic) IBOutlet UITextView *orgDescription;
@property (strong, nonatomic) IBOutlet IconImageButtonLoader *orgIcon;
@property (strong, nonatomic) IBOutlet UITextField *orgShortName;


@end
