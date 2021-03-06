//
//  FeedBackViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14/11/12.
//  Copyright (c) 2014年 gxcm. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Constants.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

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
    
    // init edit text view
    UILabel *editTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 320, 15)];
    editTitle.text = @"请输入您想要反馈的内容...";
    editTitle.font = [UIFont fontWithName:defaultBoldFont size:15];
    [self.view addSubview:editTitle];
    
    self.editText = [[UITextView alloc]initWithFrame:CGRectMake(20, 120, 280, 100)];
    self.editText.backgroundColor = defaultLightGray243;
    self.editText.font = [UIFont fontWithName:defaultFont size:15];
    [self.view addSubview:self.editText];
    
    //init right barbutton item
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"yes"] style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit:)];
    [finish setTintColor:defaultMainColor];
    self.navigationItem.rightBarButtonItem = finish;
    
    [self.editText setText:defaultV];
}

-(IBAction)finishEdit:(id)sender
{
    NSString* urlstr = @"http://e.taoware.com:8080/quickstart/api/v1/user/";
    urlstr = [urlstr stringByAppendingFormat:@"%@/%@", [[UserManager Instance]GetLocalUserId], _editText.text];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlstr]];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"成功提交问题反馈" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:true];
        }
        else
        {
            NSString* errormessage = [NSString stringWithFormat:@"服务器内部错误: %d",returnCode];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errormessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"操作失败" message:@"网络连接错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
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
