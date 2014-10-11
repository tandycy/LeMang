//
//  AddFriendViewController.m
//  LeMang
//
//  Created by LZ on 10/11/14.
//  Copyright (c) 2014 university media. All rights reserved.
//

#import "AddFriendViewController.h"
#import "Constants.h"

@interface AddFriendViewController ()


@end

@implementation AddFriendViewController
{
    UILabel* requestBK;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    requestBK = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, _requestContent.frame.size.width, 20)];
    requestBK.font = [UIFont fontWithName:defaultFont  size:15];
    requestBK.enabled = NO;//lable必须设置为不可用
    requestBK.backgroundColor = [UIColor clearColor];
    [_requestContent addSubview:requestBK];
    
    _requestContent.text = @"";
    requestBK.text = @"我是...";
    
    [self UpdateDisplay];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]init];
    rightButton.title = @"发送邀请";
    self.navigationItem.rightBarButtonItem = rightButton;
    rightButton.target = self;
    rightButton.action = @selector(OnSendRequest:);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == _requestContent) {
        if (textView.text.length == 0) {
            requestBK.text = @"我是...";
        }else{
            requestBK.text = @"";
        }
    }
}

- (IBAction)OnSendRequest:(id)sender
{
    NSString* urlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlStr = [urlStr stringByAppendingFormat:@"%@/friend/%@/", [[UserManager Instance]GetLocalUserId], userID];
    
    NSString* contentStr = _requestContent.text;
    contentStr = [contentStr URLEncodedString];
    
    urlStr = [urlStr stringByAppendingString:contentStr];
}

- (void) SetData:(NSDictionary *)data
{
    localData = data;
    userID = localData[@"id"];
}

- (void) UpdateDisplay
{
    NSString* userName = localData[@"name"];
    
    _userSchool.text = localData[@"university"][@"name"];
    _userCollage.text = localData[@"department"][@"name"];
    NSString* iconUrl = @"";
    
    NSDictionary* profileData = localData[@"profile"];
    if ([profileData isKindOfClass:[NSDictionary class]])
    {
        NSString* nickname = [UserManager filtStr:profileData[@"nickName"] : @""];
        if (nickname.length > 0)
            userName = nickname;
        
        NSString* urlStr = profileData[@"iconUrl"];
        iconUrl = [NSString stringWithFormat:@"http://e.taoware.com:8080/quickstart/resources%@", urlStr];
    }
    
    _userName.text = userName;
    [_userIcon LoadFromUrl:[NSURL URLWithString:iconUrl] :[UserManager DefaultIcon]];
}

@end
