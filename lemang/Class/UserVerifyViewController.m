//
//  UserVerifyViewController.m
//  lemang
//
//  Created by 汤 骋原 on 14-8-22.
//  Copyright (c) 2014年 university media. All rights reserved.
//

#import "UserVerifyViewController.h"

@interface UserVerifyViewController ()
{
    BOOL nameState,codeState;
}

@end

@implementation UserVerifyViewController

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
    self.userRealName.delegate = self;
    self.userCode.delegate = self;
    nameState=codeState=0;
}

-(void)initView
{
    [self.okButton addTarget:self action:@selector(okClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)okClick:(id)sender
{
    //ok function
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (nameState==0 && codeState == 0 ) {
        [self upAnim];
        if (self.userRealName.isEditing) {
            nameState = 1;
        }
        else if (self.userCode.isEditing)
        {
            codeState = 1;
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    nameState=codeState=0;
    [self downAnim];
    return 0;
}

-(void)upAnim
{
    NSTimeInterval animationDuration = 0.20f;
    CGRect frame = self.view.frame;
    frame.origin.y -= 150;
    //frame.size.height +=0;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}
-(void)downAnim
{
    NSTimeInterval animationDuration = 0.20f;
    CGRect frame = self.view.frame;
    frame.origin.y += 150;
    //frame.size.height -=0;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
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
