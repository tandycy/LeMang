//
//  ActivityDetailViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#include "UserManager.h"

@interface ActivityDetailViewController : UIViewController
{
    Activity *activity;
    NSDictionary* localData;
    NSNumber* localId;
    
    bool canBookMark;
    bool canJoin;
}

@property (nonatomic, retain) Activity *activity;

@property IBOutlet UIView *containerView;
@property IBOutlet UIToolbar *toolBar;
@property IBOutlet UIBarButtonItem *goComment;
- (IBAction)signUp:(id)sender;
- (IBAction)bookMark:(id)sender;
- (IBAction)doShare:(id)sender;
- (void)OnCommentSuccess;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *bookmarkButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *joinButton;
- (void)SetData:(NSDictionary*)actData;

@end
