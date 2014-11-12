//
//  ChangePassViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14/11/12.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import "ChangePassViewController.h"
#import "Constants.h"
#import "UserManager.h"

@interface ChangePassViewController ()
{
}

@end

@implementation ChangePassViewController

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
    
    
    //init right barbutton item
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"yes"] style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit:)];
    [finish setTintColor:defaultMainColor];
    self.navigationItem.rightBarButtonItem = finish;
    
    [self.view addSubview:_oldPass];
    [self.view addSubview:_replacePass];
    [self.view addSubview:_replacePassAgain];
    
    [self.view addSubview:_title1];
    [self.view addSubview:_title2];
    [self.view addSubview:_title3];
}

- (void)DoAlert :(NSString*)caption
{
    [self DoAlert:caption :@""];
}

- (void)DoAlert :(NSString*)caption :(NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:caption message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

-(IBAction)finishEdit:(id)sender
{
    
    if (_oldPass.text.length == 0)
    {
        [self DoAlert:@"旧密码不能为空"];
        return;
    }
    if (_replacePass.text.length == 0)
    {
        [self DoAlert:@"新密码不能为空"];
        return;
    }
    if (_replacePass.text.length < 6)
    {
        [self DoAlert:@"新密码长度不能小于6位"];
        return;
    }
    if (![_oldPass.text isEqualToString:[UserManager UserPW]])
    {
        [self DoAlert:@"旧密码不正确"];
        return;
    }
    if(![_replacePass.text isEqualToString:_replacePassAgain.text])
    {
        [self DoAlert:@"两次密码不一致"];
        return;
    }
    
    NSString* newPass = _replacePass.text;
    
    NSString* userUrlStr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    userUrlStr = [userUrlStr stringByAppendingFormat:@"%@/basic", [[UserManager Instance]GetLocalUserId]];
    ASIHTTPRequest *updateRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:userUrlStr]];
    
    NSString* postStr = @"{\"plainPassword\":";
    postStr = [postStr stringByAppendingFormat:@"\"%@\"}", newPass];
    
    [updateRequest addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    [updateRequest appendPostData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
    [updateRequest setRequestMethod:@"PUT"];
    
    [updateRequest startSynchronous];
    
    NSError *error = [updateRequest error];
    
    if (!error)
    {
        int returnCode = [updateRequest responseStatusCode];
        
        if (returnCode == 200)
        {
            [self DoAlert:@"修改密码完成"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString* content = [NSString stringWithFormat:@"服务器内部错误:%d",returnCode];
            [self DoAlert:@"操作失败" :content];
        }
    }
    else
    {
        [self DoAlert:@"操作失败" :@"网络连接错误"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavBar
{
    [self setBackButton];
    [self changeToWhite];
}

-(void)setBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navBackClick:)];
    [backButton setTintColor:defaultMainColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(IBAction)navBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)changeToWhite
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     defaultMainColor, UITextAttributeTextColor,
                                                                     [UIFont fontWithName:defaultBoldFont size:20.0], UITextAttributeFont,
                                                                     nil]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [self initNavBar];
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
