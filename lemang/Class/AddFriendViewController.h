//
//  AddFriendViewController.h
//  LeMang
//
//  Created by LZ on 10/11/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "IconImageViewLoader.h"

@interface AddFriendViewController : UIViewController <UITextViewDelegate>
{
    NSDictionary* localData;
    NSNumber* userID;
}

@property (strong, nonatomic) IBOutlet IconImageViewLoader *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userSchool;
@property (strong, nonatomic) IBOutlet UILabel *userCollage;
@property (strong, nonatomic) IBOutlet UITextView *requestContent;
- (void) SetData:(NSDictionary*)data;

@end
