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
    
    //init right barbutton item
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishBond:)];
    self.navigationItem.rightBarButtonItem = finish;
    
    //[self.editText setText:defaultV];
}

-(IBAction)sendMP:(id)sender
{
    //send MP number function
}

-(IBAction)finishBond:(id)sender
{
    //verify return code and user input
    //if ok ,send bond ok to server
    
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
