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
    if (_oldPass.text != [UserManager UserPW])
    {
        [self DoAlert:@"旧密码不正确"];
        return;
    }
    if(![_replacePass.text isEqualToString:_replacePassAgain.text])
    {
        [self DoAlert:@"两次密码不一致"];
        return;
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
