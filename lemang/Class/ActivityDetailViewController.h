//
//  ActivityDetailViewController.h
//  lemang
//
//  Created by 汤 骋原 on 14-7-29.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailViewController : UIViewController
{
    NSString *title;
}

@property (nonatomic, retain) NSString *title;

@property IBOutlet UIView *containerView;
@property IBOutlet UIToolbar *toolBar;

@end
