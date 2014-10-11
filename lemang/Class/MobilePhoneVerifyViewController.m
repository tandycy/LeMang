//
//  MobilePhoneVerifyViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-28.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "MobilePhoneVerifyViewController.h"
#import "Constants.h"

@interface MobilePhoneVerifyViewController ()

@end

@implementation MobilePhoneVerifyViewController
{
    UITextField* verifyText;
    UILabel* resultLabel;
    UIAlertView* endMessageView;
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
    [self initView];
}

-(void)initView
{
    // init view with white bg
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.title = @"绑定手机";
    // init edit text view
    UILabel *editTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 320, 15)];
    editTitle.text = @"请输入您的手机号码获取绑定所需的验证码";
    editTitle.font = [UIFont fontWithName:defaultBoldFont size:15];
    [self.view addSubview:editTitle];
    
    self.mobliePhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 150, 30)];
    [self.mobliePhoneNumber setBorderStyle:UITextBorderStyleRoundedRect];
    self.mobliePhoneNumber.placeholder = @"请输入您的手机号码";
    self.mobliePhoneNumber.backgroundColor = defaultLightGray243;
    self.mobliePhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.mobliePhoneNumber.font = [UIFont fontWithName:defaultFont size:15];
    [self.view addSubview:self.mobliePhoneNumber];
    
    //init sendMP button
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 120, 90, 28)];
    [button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendMP:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //init verify button input view
    UITextField *verifyCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 160, 150, 30)];
    [verifyCode setBorderStyle:UITextBorderStyleRoundedRect];
    verifyCode.backgroundColor = defaultLightGray243;
    verifyCode.font = [UIFont fontWithName:defaultFont size:15];
    verifyCode.placeholder = @"请输入获取的验证码";
    [self.view addSubview:verifyCode];
    
    verifyText = verifyCode;
    
    //init right barbutton item
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishBond:)];
    self.navigationItem.rightBarButtonItem = finish;
    
    
    if ([UserManager IsTestVersion])
    {
        resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, 320, 60)];
        resultLabel.text = @"";
        resultLabel.font = [UIFont fontWithName:defaultBoldFont size:15];
        [self.view addSubview:resultLabel];
    }
    
    //[self.editText setText:defaultV];
}

-(IBAction)sendMP:(id)sender
{
    //send MP number function
    if (_mobliePhoneNumber.text.length != 11)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号错误" message:@"请输入11位手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    NSString* urlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlStr = [urlStr stringByAppendingFormat:@"%@/validate/%@",[[UserManager Instance]GetLocalUserId], _mobliePhoneNumber.text];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setRequestMethod:@"PUT"];
    [request startSynchronous];
    
    NSError* error = [request error];
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送信息失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        resultLabel.text = @"";
        return;
    }
    
    int returnCode = [request responseStatusCode];
    NSNumber* resp = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingAllowFragments error:nil];;
    
    if ([resp isKindOfClass:[NSNumber class]])
    {
        verifyNum = resp;
        
        if ([UserManager IsTestVersion])
            resultLabel.text = [NSString stringWithFormat:@"验证码：%@",verifyNum];
    }
    else
    {
        verifyNum = nil;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取验证码失败" message:@"服务器内部错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        resultLabel.text = @"";
        return;
    }
}

-(IBAction)finishBond:(id)sender
{
    //verify return code and user input
    //if ok ,send bond ok to server
    if (!verifyNum)
        return;
    
    NSString* codeStr = [NSString stringWithFormat:@"%@",verifyNum];
    
    if ([verifyText.text isEqualToString:codeStr])
    {
        NSString* urlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
        urlStr = [urlStr stringByAppendingFormat:@"%@/bind/%@",[[UserManager Instance]GetLocalUserId], _mobliePhoneNumber.text];
        
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request setRequestMethod:@"PUT"];
        [request startSynchronous];
        
        NSError* error = [request error];
        if (error)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        
        int returnCode = [request responseStatusCode];
        
        if (returnCode == 200)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证成功" message:@"成功验证手机号" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            endMessageView = alertView;
            [alertView show];
            return;
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证失败" message:@"验证码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger*)buttonIndex
{
    if ((id)alertView == (id)endMessageView)
    {
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
