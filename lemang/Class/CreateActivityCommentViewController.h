//
//  CreateActivityCommentViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-9-13.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "UserManager.h"
#import "Activity.h"

@interface CreateActivityCommentViewController : UIViewController<UITextViewDelegate>
{
    UIImagePickerController *imagePicker;
    UIImage *image;
    Activity* linkedActivity;
}

@property (strong, nonatomic) IBOutlet UIImageView *imgViewBig;
@property (strong, nonatomic) IBOutlet UIButton *addPhoto;
@property (strong, nonatomic) IBOutlet UITextView *commentDetail;
@property (strong, nonatomic) IBOutlet UIImageView *rateStar;

- (void) SetActivity:(Activity*)activity;

@end
