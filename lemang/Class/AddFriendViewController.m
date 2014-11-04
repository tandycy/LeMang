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
    rightButton.tintColor = defaultMainColor;
    self.navigationItem.rightBarButtonItem = rightButton;
    rightButton.target = self;
    rightButton.action = @selector(OnSendRequest:);
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_requestContent resignFirstResponder];
}

-(void)downAnim
{
    NSTimeInterval animationDuration = 0.20f;
    CGRect frame = self.view.frame;
    frame.origin.y += 120;
    frame.size.height -=10;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 120;
    frame.size.height +=10;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self downAnim];
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
    
    NSLog(@"%@",contentStr);
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setUsername:[UserManager UserName]];
    [request setPassword:[UserManager UserPW]];
    [request setRequestMethod:@"PUT"];
    
    [request startSynchronous];
    
    NSError* error = [request error];
    
    if (!error)
    {
        int returnCode = [request responseStatusCode];
    
        if (returnCode == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邀请成功" message:@"已经向该用户发送好友邀请" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:true];
        }
        else
        {
            NSString* errormessage = [NSString stringWithFormat:@"服务器内部错误: %d",returnCode];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邀请失败" message:errormessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"邀请失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
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
