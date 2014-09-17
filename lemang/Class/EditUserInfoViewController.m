//
//  EditUserInfoViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-9-17.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "Constants.h"

@interface EditUserInfoViewController ()

@end

@implementation EditUserInfoViewController

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
    editTitle.text = @"请输入您想要修改的内容...";
    editTitle.font = [UIFont fontWithName:defaultBoldFont size:15];
    [self.view addSubview:editTitle];
    
    self.editText = [[UITextView alloc]initWithFrame:CGRectMake(20, 120, 280, 100)];
    self.editText.backgroundColor = defaultLightGray243;
    self.editText.font = [UIFont fontWithName:defaultFont size:15];
    [self.view addSubview:self.editText];
    
    //init right barbutton item
    UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishEdit:)];
    self.navigationItem.rightBarButtonItem = finish;
}

-(IBAction)finishEdit:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
