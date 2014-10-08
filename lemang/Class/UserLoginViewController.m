//
//  UserLoginViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "UserLoginViewController.h"
#import "UserTableViewController.h"
#import "UserRegisterViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

@synthesize userName, userPass;
@synthesize owner;

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
    [self initUserLoginView];
    
    //click anywhere hide keyboard
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [userName resignFirstResponder];
    [userPass resignFirstResponder];
}

-(void)initUserLoginView
{
    // init view with white bg
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //init user head button with click response
    UIButton *headButton  = [[UIButton alloc]initWithFrame:CGRectMake(125, 50, 70, 70)];
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    headImg.image = [UIImage imageNamed:@"user_icon_de.png"];
    headImg.contentMode = UIViewContentModeScaleToFill;
    [headButton addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
    [headButton addSubview:headImg];
    [self.view addSubview:headButton];
    
    //init username and password input field
    userName = [[UITextField alloc]initWithFrame:CGRectMake(50, 140, 220, 30)];
    userName.backgroundColor = [UIColor lightGrayColor];
    userName.placeholder = @"请输入您的用户名...";
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:userName];
    
    userPass = [[UITextField alloc]initWithFrame:CGRectMake(50, 180, 220, 30)];
    userPass.backgroundColor = [UIColor lightGrayColor];
    userPass.placeholder = @"请输入您的密码...";
    userPass.keyboardType = UIKeyboardTypeAlphabet;
    userPass.secureTextEntry = true;
    [self.view addSubview:userPass];
    
    //init ok and cancel button
    UIButton *ok = [[UIButton alloc]initWithFrame:CGRectMake(60, 220, 80, 35)];
    //[ok setBackgroundColor:[UIColor blueColor]];
    [ok setImage:[UIImage imageNamed:@"comfirm"] forState:UIControlStateNormal];
    [ok addTarget:self action:@selector(okClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(180, 220, 80, 35)];
    [cancel setImage:[UIImage imageNamed:@"canncel"]forState:UIControlStateNormal];
    //[cancel setBackgroundColor:[UIColor blueColor]];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ok];
    [self.view addSubview:cancel];
    
    //init forget password and regist button
    UIButton *forgetPass = [[UIButton alloc]initWithFrame:CGRectMake(38, self.view.frame.size.height-40, 82, 23)];
    //[forgetPass setBackgroundColor:[UIColor blueColor]];
    [forgetPass setImage:[UIImage imageNamed:@"fogetpass"] forState:UIControlStateNormal];
    [forgetPass addTarget:self action:@selector(forgetPassClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *regist = [[UIButton alloc]initWithFrame:CGRectMake(200, self.view.frame.size.height-40, 82, 23)];
    [regist setImage:[UIImage imageNamed:@"register"] forState:UIControlStateNormal];
    //[regist setBackgroundColor:[UIColor blueColor]];
    [regist addTarget:self action:@selector(registClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgetPass];
    [self.view addSubview:regist];
}

- (void) UserLoginContact : (int)returnCode
{
    if ([UserManager IsInitSuccess])
    {
        // TODO: return to previous page and refresh
        NSLog(@"Log in success");
        //[[UserManager Instance] UpdateLocalData];
        
        [self dismissModalViewControllerAnimated:YES];
        
        if ([owner isKindOfClass:[UserTableViewController class]])
        {
            [(UserTableViewController*)owner refreshUserData];
        }
    }
    else
    {
        NSString* state = [NSString stringWithFormat:@"服务器错误：%d", returnCode];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:state delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        NSLog(@"Log in fail.");
    }
}

-(void)headClick:(UIButton*)button
{
    //do head button click
}

-(void)okClick:(UIButton*)button
{
    //do ok button click
    
    [UserManager Instance].loginDelegate = self;
    [[UserManager Instance] DoLogIn:userName.text :userPass.text];
}

-(void)cancelClick:(UIButton*)button
{
    //do cancel button click
    [self dismissModalViewControllerAnimated:YES];
}

-(void)forgetPassClick:(UIButton*)button
{
    //do forgetPass button click
    //jump to forgetpass view? or html5
}

-(void)registClick:(UIButton*)button
{
    //do regist button click
    //jump to registpass view
    //[self dismissModalViewControllerAnimated:YES];
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
    UserRegisterViewController *URVL = [self.storyboard instantiateViewControllerWithIdentifier:@"UserRegisterViewController"];
    NSLog(@"%@",URVL);
    //[nav pushViewController:URVL animated:YES];
    [self presentModalViewController:URVL animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
