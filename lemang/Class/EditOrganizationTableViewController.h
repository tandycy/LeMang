//
//  EditOrganizationTableViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-27.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IconImageButtonLoader.h"

@interface EditOrganizationTableViewController : UITableViewController
{
    UIImagePickerController *imagePicker;
    NSMutableDictionary* orgData;
    
    UIImage* localNewIcon;
    UIImage* originIcon;
    
    UIViewController* rootVC;
}

@property (strong, nonatomic) IBOutlet UITextView *orgName;
@property (strong, nonatomic) IBOutlet UITextView *orgDescription;
@property (strong, nonatomic) IBOutlet IconImageButtonLoader *orgIcon;
@property (strong, nonatomic) IBOutlet UITextField *orgShortName;
@property (strong, nonatomic) IBOutlet UIButton *CancelPhotoButton;

- (void)SetOrganizationData:(NSDictionary*)data;
- (void)SetOrganizationDataFromId:(NSNumber*)orgId;
- (void)SetRootView:(UIViewController*)vc;


@end
